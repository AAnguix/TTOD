#include "globals.fxh"
#include "functions.fxh"
#include "samplers.fxh"

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
	float3 Normal : TEXCOORD1;
	float4 HPos : TEXCOORD2;
};
struct PixelOutputType
{
	float4 Target0 : SV_Target0; //Albedo (float3) + (float) SpecularFactor
	float4 Target1 : SV_Target1; //AmbientLight (float3) + (float) SpecularPow
	float4 Target2 : SV_Target2; //Normal (float3) + (float) Not used
	float4 Target3 : SV_Target3; //Depth (float4)
};
//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT IN )
{
	PS_INPUT l_Output = (PS_INPUT)0;
	
	l_Output.Pos = mul( IN.Pos, m_World );
	l_Output.Pos = mul( l_Output.Pos, m_View );
	l_Output.Pos = mul( l_Output.Pos, m_Projection );
	l_Output.HPos = l_Output.Pos;
	
	l_Output.UV = IN.UV;
	l_Output.Normal = normalize(mul(normalize(IN.Normal).xyz, (float3x3)m_World));
	return l_Output;
}
//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
PixelOutputType PS( PS_INPUT IN) : SV_Target
{
	PixelOutputType l_Output;

	float l_SpecularFactor = 1.0f;
    l_Output.Target0.xyz = T0Texture.Sample(S0Sampler, IN.UV);
	l_Output.Target0.w = l_SpecularFactor;
	
	float l_SpecularPower = 1.0f;
	l_Output.Target1.xyz = m_LightAmbient.xyz*l_Output.Target0.xyz;
	l_Output.Target1.w = l_SpecularPower;
	
    l_Output.Target2 = float4(Normal2Texture(IN.Normal.xyz), 1.0f); //Alpha not used
	
	float l_Depth = IN.HPos.z / IN.HPos.w;
	l_Output.Target3 = float4(l_Depth, l_Depth, l_Depth, 1.0);
    return l_Output;
}