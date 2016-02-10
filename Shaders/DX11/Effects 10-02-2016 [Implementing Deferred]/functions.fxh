float3 Normal2Texture(float3 Normal)
{
	return Normal*0.5+0.5;
}

float3 Texture2Normal(float3 Color)
{
	return (Color-0.5)*2;
}

float4 Red()
{
	return float4(1.0,0.0,0.0,1.0);
}


float4 Green()
{
	return float4(0.0,1.0,0.0,1.0);
}


float4 Blue()
{
	return float4(0.0,0.0,1.0,1.0);
}

//Depth to World Cords
float3 GetPositionFromZDepthViewInViewCoordinates(float ZDepthView, float2 UV, float4x4 InverseProjection)
{
	// Get the depth value for this pixel
	// Get x/w and y/w from the viewport position
	float x = UV.x * 2 - 1;
	float y = (1 - UV.y) * 2 - 1;
	float4 l_ProjectedPos = float4(x, y, ZDepthView, 1.0);
	
	// Transform by the inverse projection matrix
	float4 l_PositionVS = mul(l_ProjectedPos, InverseProjection);
	
	// Divide by w to get the view-space position
	return l_PositionVS.xyz / l_PositionVS.w;
}

float3 GetPositionFromZDepthView(float ZDepthView, float2 UV, float4x4 InverseView, float4x4 InverseProjection)
{
	float3 l_PositionView=GetPositionFromZDepthViewInViewCoordinates(ZDepthView, UV, InverseProjection);
	return mul(float4(l_PositionView,1.0), InverseView).xyz;
}

/*FOG EQUATIONS*/

float CalcAttenuation(float Depth, float StartFog, float EndFog)
{
	return ((EndFog-Depth)/(EndFog-StartFog));
}

float4 CalcLinearFog(float Depth, float StartFog, float EndFog, float3 FogColor)
{
	return float4(FogColor, 1.0-CalcAttenuation(Depth, StartFog, EndFog));
}

float4 CalcExp2Fog(float Depth, float ExpDensityFog, float3 FogColor)
{
	const float LOG2E = 1.442695; // = 1 / log(2)
	float l_Fog = exp2(-ExpDensityFog * ExpDensityFog * Depth * Depth * LOG2E);
	return float4(FogColor, 1.0-l_Fog);
}

float4 CalcExpFog(float Depth, float ExpDensityFog, float3 FogColor)
{
	const float LOG2E = 1.442695; // = 1 / log(2)
	float l_Fog = exp2(-ExpDensityFog * Depth * LOG2E);
	return float4(FogColor, 1.0-l_Fog);
}

/*
float3 GetFogColor(float Depth, float3 CurrentColor)
{
	float4 l_FogColor=CalcLinearFog(Depth, m_StartLinearFog, m_EndLinearFog, m_FogColor);
	return float3(CurrentColor*(1.0-l_FogColor.a)+l_FogColor.xyz*l_FogColor.a);
}*/

