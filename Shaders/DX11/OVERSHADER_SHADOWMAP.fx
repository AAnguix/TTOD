#include "globals.fxh"
#include "functions.fxh"
#include "LightFunctions.fxh"

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
	//if(IN.UV.x<0.5)
	//	clip(-1);

	float4 l_DiffuseMap = T0Texture.Sample(S0Sampler, IN.UV);
	float4 l_NormalMap = T1Texture.Sample(S1Sampler, IN.UV);
	float l_Depth = T2Texture.Sample(S2Sampler, IN.UV).r;
	
	float l_SpecularPower=60.0f;
	float3 l_WorldPos=GetPositionFromZDepthView(l_Depth, IN.UV,m_InverseView, m_InverseProjection);
	float3 l_WorldNormal = Texture2Normal(l_NormalMap.xyz);
	
	return float4(GetIluminatedPixelColor(l_DiffuseMap,l_SpecularPower,l_WorldPos,l_WorldNormal,m_LightAmbient, 1,true));
}
