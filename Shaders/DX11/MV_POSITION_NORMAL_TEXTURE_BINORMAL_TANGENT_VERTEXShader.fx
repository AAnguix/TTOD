#include "globals.fxh"
#include "LightFunctions.fxh"
#include "samplers.fxh"
//--------------------------------------------------------------------------------------
struct VS_INPUT
{
	float3 Pos : POSITION;
	float3 Normal : NORMAL;
	float4 Tangent : TANGENT;
	float4 Binormal : BINORMAL;
	float2 UV : TEXCOORD0;
};
struct PS_INPUT
{
	float4 Pos : SV_POSITION;
	float2 UV : TEXCOORD0;
	float3 WorldNormal : TEXCOORD1;
	float3 WorldTangent : TEXCOORD2;
	float3 WorldBinormal : TEXCOORD3;
	float3 WorldPos: TEXCOORD4;
};
//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT IN )
{
	PS_INPUT l_Output = (PS_INPUT)0;
	l_Output.Pos = mul( float4(IN.Pos.xyz,1.0), m_World ); 
	l_Output.WorldPos=l_Output.Pos.xyz;
	l_Output.Pos = mul( l_Output.Pos, m_View );
	l_Output.Pos = mul( l_Output.Pos, m_Projection );
	l_Output.UV = IN.UV;
	
	l_Output.WorldNormal = normalize(mul(normalize(IN.Normal).xyz, (float3x3)m_World));
	l_Output.WorldTangent = mul(IN.Tangent.xyz,(float3x3)m_World);
	l_Output.WorldBinormal = mul(cross(IN.Tangent.xyz,IN.Normal),(float3x3)m_World);
	
	return l_Output;
}
//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT IN) : SV_Target
{
	float l_SpecularPower=10.0f;
	float l_Depht=2.4f;
	
	float4 l_DiffuseTexture = T0Texture.Sample(S0Sampler, IN.UV);
	float4 l_NormalMapTexture = T1Texture.Sample(S1Sampler, IN.UV);
	
	float3 l_TangentNormalized=normalize(IN.WorldTangent);
	float3 l_BinormalNormalized=normalize(IN.WorldBinormal); 

	float3 l_Bump=l_Depht*(l_NormalMapTexture.rgb - float3(0.5,0.5,0.5));	
	
	float3 Nn = normalize(IN.WorldNormal);
	Nn = Nn + (l_Bump.x*l_TangentNormalized) + (l_Bump.y*l_BinormalNormalized);
	//Nn = normalize(Nn); 
	
	float3 l_PixelColor = GetIluminatedPixelColor(l_DiffuseTexture,l_SpecularPower,IN.WorldPos,Nn, m_LightAmbient, MAX_LIGHTS_BY_SHADER);
	return float4(l_PixelColor,l_DiffuseTexture.a);
}