#include "globals.fxh"
#include "functions.fxh"
#include "samplers.fxh"

static float m_NoisePct=0.5;
static float m_VignettingPct=1.0;
static float m_NoiseAmount=1.0;
static float m_Time = 0.1;
//--------------------------------------------------------------------------------------
struct VS_INPUT
{
	float4 Pos : POSITION;
	float3 Normal : NORMAL;
	float2 UV : TEXCOORD0;
};
struct PS_INPUT
{
	float4 Pos : SV_POSITION;
	float2 UV : TEXCOORD0;
};
//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT IN )
{
	PS_INPUT l_Output = (PS_INPUT)0;
	l_Output.UV = IN.UV;
	
	return l_Output;
}
//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT IN) : SV_Target
{ 
	float l_NoiseX=m_Time*sin(IN.UV.x*IN.UV.y+m_Time);
	l_NoiseX=fmod(l_NoiseX, 8)*fmod(l_NoiseX, 4);
	float l_DistortX=fmod(l_NoiseX, m_NoiseAmount);
	float l_DistortY=fmod(l_NoiseX, m_NoiseAmount+0.002);
	float2 l_DistortUV=float2(l_DistortX, l_DistortY);
	float4 l_Noise=T0Texture.Sample(S0Sampler, IN.UV+l_DistortUV)*m_NoisePct;
	float4 l_Vignetting=T1Texture.Sample(S1Sampler, IN.UV)*m_VignettingPct;
	return float4 (1.0,0.0,0.0,1.0);
	return l_Noise+l_Vignetting;
}
