#include "globals.fxh"
#include "samplers.fxh"
#include "functions.fxh"

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
PS_INPUT VS(VS_INPUT IN)
{
	PS_INPUT l_Output = (PS_INPUT)0;
	l_Output.Pos=IN.Pos;
	l_Output.Color=IN.Color;
	l_Output.UV=IN.UV;
	return l_Output;
}
float4 PS(PS_INPUT IN) : SV_Target
{
	float4 l_DiffuseMap = T0Texture.Sample(S0Sampler, IN.UV);
	float4 l_NormalMap = T1Texture.Sample(S1Sampler, IN.UV);
	float4 l_DepthMap = T2Texture.Sample(S2Sampler, IN.UV);
	
	float3 l_DiffuseLight;
	float3 l_SpecularLight;
	float4 l_Return;
	
	return l_DiffuseMap;
	
	/*
	if(m_LightEnabledArray[0]==1.0f) //Enabled
	{
		float l_Depth=l_DepthMap.r;
		float3 l_WorldPos=GetPositionFromZDepthView(l_Depth, IN.UV, m_InverseView,m_InverseProjection);
		
		if(m_LightTypeArray[0]==0.0f) //OMNI
		{
		
		}
		else if(m_LightTypeArray[0]==1.0f) //DIRECTIONAL
		{
			float3 Hn=normalize(normalize(m_CameraPosition-l_WorldPos)-m_LightDirection[0]);	
			
			float3 l_WorldNormal = Texture2Normal(l_NormalMap.xyz);
			float3 Nn=normalize(l_WorldNormal);
			
			float l_DiffuseContrib=max(0.0, dot(Nn, -m_LightDirection[0]));
			
			float l_SpecularContrib=pow(max(0, dot(Hn, Nn)), l_SpecularPower);
			
			l_DiffuseLight+=(l_DiffuseContrib * m_LightColor[0].xyz * l_DiffuseMap.xyz * m_LightIntensityArray[0]);
			
			l_SpecularLight+=(l_SpecularContrib *  m_LightColor[0].xyz * m_LightIntensityArray[0]);
		
		}
		else if(m_LightTypeArray[i]==2.0f) //SPOT
		{
		
		}
	}*/
	
	//return clamp(float3(l_SpecularLight),0,1) + clamp(float3(l_DiffuseLight),0,1), l_DiffuseMap.a );
}