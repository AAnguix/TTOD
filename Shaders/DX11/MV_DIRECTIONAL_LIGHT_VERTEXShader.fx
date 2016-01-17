#include "globals.fxh"

Texture2D DiffuseTexture : register( t0 );
SamplerState LinearSampler : register( s0 );

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
	float3 WorldNormal : TEXCOORD1;
	float3 WorldPos: TEXCOORD2;
};
//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT IN )
{
	PS_INPUT l_Output = (PS_INPUT)0;
	l_Output.Pos = mul( IN.Pos, m_World );
	l_Output.WorldPos=l_Output.Pos.xyz;
	l_Output.Pos = mul( l_Output.Pos, m_View );
	l_Output.Pos = mul( l_Output.Pos, m_Projection );
	l_Output.UV = IN.UV;
	l_Output.WorldNormal = normalize(mul(normalize(IN.Normal).xyz, (float3x3)m_World));
	return l_Output;
}
//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS( PS_INPUT IN) : SV_Target
{
	float l_SpecularPower=80.0f;
	int i;
	for(i=0;i<MAX_LIGHTS_BY_SHADER;++i)
	{ 
		if(m_LightEnabledArray[i]==1.0f) //Enabled
		{
			if(m_LightTypeArray[i]==0.0f) //OMNI
			{
				return float4(0.0f,1.0,0.0f,1.0f);
			}
			else if(m_LightTypeArray[i]==1.0f) //DIRECTIONAL
			{
				float3 Hn=normalize(normalize(m_CameraPosition-IN.WorldPos)-m_LightDirection[i]);	
				float3 Nn=normalize(IN.WorldNormal);
				float l_DiffuseContrib=max(0.0, dot(Nn, -m_LightDirection[i]))*m_LightIntensityArray[i];
				float l_SpecularContrib=pow(max(0, dot(Hn, Nn)), l_SpecularPower)*m_LightIntensityArray[i];
				float4 l_Texture=DiffuseTexture.Sample(LinearSampler, IN.UV);
				return float4(l_Texture.xyz*m_LightAmbient.xyz+l_DiffuseContrib*m_LightColor[i].xyz*l_Texture.xyz+l_SpecularContrib*m_LightColor[i].xyz, l_Texture.a);
			}
			else if(m_LightTypeArray[i]==2.0f) //SPOT
			{
				return float4(0.0f,0.0,1.0f,1.0f);
			}
		}
	}
	
	return DiffuseTexture.Sample(LinearSampler, IN.UV);
}