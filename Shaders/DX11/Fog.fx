#include "globals.fxh"
#include "samplers.fxh"

//--------------------------------------------------------------------------------------
struct VS_INPUT
{
	float4 Pos : POSITION;
	float4 Color : COLOR0;
	float2 UV : TEXCOORD0;
};
struct PS_INPUT
{
	float4 Pos : SV_POSITION;
	float4 Color : COLOR0;
	float2 UV : TEXCOORD0;
};

float CalcAttenuation(float Depth, float StartFog, float EndFog)
{
	return ((EndFog-Depth)/(EndFog-StartFog));
}

float4 CalcLinearFog(float Depth, float StartFog, float EndFog, float3 FogColor)
{
	return float4(FogColor, 1.0-CalcAttenuation(Depth, StartFog, EndFog));
}

float4 CalcExpFog(float Depth, float ExpDensityFog, float3 FogColor)
{
	const float LOG2E = 1.442695; // = 1 / log(2)
	float l_Fog = exp2(-ExpDensityFog * Depth * LOG2E);
	return float4(FogColor, 1.0-l_Fog);
}

/*Stronger values at longer distances*/
float4 CalcExp2Fog(float Depth, float ExpDensityFog, float3 FogColor)
{
	const float LOG2E = 1.442695; // = 1 / log(2)
	float l_Fog = exp2(-ExpDensityFog * ExpDensityFog * Depth * Depth * LOG2E);
	return float4(FogColor, 1.0-l_Fog);
}

float3 GetFogColor(float Depth, float3 CurrentColor)
{
	float4 l_FogColor=CalcLinearFog(Depth, m_FogParameters.x, m_FogParameters.y, m_FogColor.rgb);
	//float4 l_FogColor=CalcExpFog(Depth, m_FogParameters.z, m_FogColor.rgb);
	//float4 l_FogColor=CalcExp2Fog(Depth, m_FogParameters.z, m_FogColor.rgb);
	return float3(CurrentColor*(1.0-l_FogColor.a)+l_FogColor.xyz*l_FogColor.a);
}

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT IN )
{
	PS_INPUT l_Output = (PS_INPUT)0;
	l_Output.Pos=IN.Pos;
	l_Output.Color=IN.Color;
	l_Output.UV=IN.UV;
	return l_Output;
}
//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT IN) : SV_Target
{
	float4 l_FinalColor = T0Texture.Sample(S0Sampler, IN.UV);
	float3 l_WorldPos=T1Texture.Sample(S1Sampler, IN.UV).xyz;
	//return float4(l_WorldPos,1.0);
	float l_DistanceEyeToWorldPosition=length(l_WorldPos-m_InverseView[3].xyz); //m_InverseView[3].xyz
	return float4(GetFogColor(l_DistanceEyeToWorldPosition, l_FinalColor.xyz), l_FinalColor.a);
}