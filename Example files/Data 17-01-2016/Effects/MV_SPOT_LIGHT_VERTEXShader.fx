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
				return float4(1.0f,0.0,0.0f,1.0f);
			}
			else if(m_LightTypeArray[i]==1.0f) //DIRECTIONAL
			{
				return float4(0.0f,1.0,0.0f,1.0f);
			}
			else if(m_LightTypeArray[i]==2.0f) //SPOT
			{
				float3 lightDirection = m_LightPosition[i] - IN.WorldPos; //Punto final - Punto inicio
				float l_Distance=length(lightDirection);
				float l_Attenuation = 1 - saturate((l_Distance-m_LightAttenuationStartRangeArray[i])/(m_LightAttenuationEndRangeArray[i]-m_LightAttenuationStartRangeArray[i]));
				lightDirection/=l_Distance; //Normalize
				
				float l_CosAngle=cos(m_LightAngleArray[i]*0.5*3.1416/180.0);
				float l_CosFallOff=cos(m_LightFallOffAngleArray[i]*0.5*3.1416/180.0);
				float l_DotLight=dot(lightDirection, -m_LightDirection[i]);
				float l_SpotAttenuation=saturate((l_DotLight-l_CosFallOff)/(l_CosAngle-l_CosFallOff));
				
				float3 l_Normal=normalize(IN.WorldNormal);
				
				float l_DiffuseContrib=max(0.0, dot(l_Normal, lightDirection));
				
				float3 l_HalfWayVector=normalize(normalize(m_CameraPosition-IN.WorldPos)+lightDirection);
				float l_SpecularContrib=pow(max(0, dot(l_HalfWayVector, l_Normal)), l_SpecularPower);
				
				float4 l_Texture=DiffuseTexture.Sample(LinearSampler, IN.UV);
				
				//Cálculo luces
				float3 l_AmbientLight=l_Texture.xyz*m_LightAmbient.xyz;
				
				float3 l_DiffuseLight=l_DiffuseContrib * m_LightColor[i].xyz * l_Texture.xyz * m_LightIntensityArray[i] * l_Attenuation * l_SpotAttenuation;
				
				float3 l_SpecularLight=l_SpecularContrib * m_LightColor[i].xyz * m_LightIntensityArray[i] * l_Attenuation * l_SpotAttenuation; 
				
				return float4(l_AmbientLight+l_SpecularLight+l_DiffuseLight, l_Texture.a);	
			}
		}
	}
	
	return DiffuseTexture.Sample(LinearSampler, IN.UV);
}