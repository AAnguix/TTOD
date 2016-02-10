#include "globals.fxh"
#include "Samplers.fxh"

//--------------------------------------------------------------------------------------
struct VS_INPUT
{
	float4 Pos : POSITION;
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
	l_Output.Pos = mul( IN.Pos, m_World );
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
	float l_SpecularPower=80.0f;
	int i;
	
	float4 l_Texture=T0Texture.Sample(S0Sampler, IN.UV);
	float3 l_AmbientLight=(l_Texture.xyz*m_LightAmbient.xyz);
	float3 l_DiffuseLight;
	float3 l_SpecularLight;
	
	float3 l_TangentNormalized=normalize(IN.WorldTangent);
	float3 l_BinormalNormalized=normalize(IN.WorldBinormal); 
	
	float l_Depht=2.4f;
	
	float4 l_NormalMapTexture = T1Texture.Sample(S1Sampler, IN.UV);
	
	float3 l_Bump=l_Depht*(l_NormalMapTexture.rgb - float3(0.5,0.5,0.5));	
	
	float3 bumpNormal = normalize(IN.WorldNormal);
	bumpNormal = bumpNormal + (l_Bump.x*l_TangentNormalized) + (l_Bump.y*l_BinormalNormalized);
	bumpNormal = normalize(bumpNormal); 
	
	for(i=0;i<MAX_LIGHTS_BY_SHADER;++i)
	{ 
		if(m_LightEnabledArray[i]==1.0f) //Enabled
		{
			if(m_LightTypeArray[i]==0.0f) //OMNI
			{
				float3 lightDirection = m_LightPosition[i] - IN.WorldPos; //Punto final - Punto inicio
				float l_Distance=length(lightDirection);
				float l_Attenuation = 1 - saturate((l_Distance-m_LightAttenuationStartRangeArray[i])/(m_LightAttenuationEndRangeArray[i]-m_LightAttenuationStartRangeArray[i]));
				lightDirection/=l_Distance; //Normalize
					
				//float3 l_Normal=normalize(IN.WorldNormal);
				
				float l_DiffuseContrib=max(0.0, dot(bumpNormal, lightDirection));
				
				float3 l_HalfWayVector=normalize(normalize(m_CameraPosition-IN.WorldPos)+lightDirection);
	
				float l_SpecularContrib=pow(max(0, dot(l_HalfWayVector, bumpNormal)), l_SpecularPower);
			
				l_DiffuseLight+=(l_DiffuseContrib * m_LightColor[i].xyz * l_Texture.xyz * m_LightIntensityArray[i] * l_Attenuation);
				
				l_SpecularLight+=(l_SpecularContrib * m_LightColor[i].xyz * m_LightIntensityArray[i] * l_Attenuation); 

			}
			else if(m_LightTypeArray[i]==1.0f) //DIRECTIONAL
			{
				float3 Hn=normalize(normalize(m_CameraPosition-IN.WorldPos)-m_LightDirection[i]);	
				
				//float3 Nn=normalize(IN.WorldNormal);
				
				float l_DiffuseContrib=max(0.0, dot(bumpNormal, -m_LightDirection[i]));
				
				float l_SpecularContrib=pow(max(0, dot(Hn, bumpNormal)), l_SpecularPower);
				
				l_DiffuseLight+=(l_DiffuseContrib * m_LightColor[i].xyz * l_Texture.xyz * m_LightIntensityArray[i]);
				
				l_SpecularLight+=(l_SpecularContrib *  m_LightColor[i].xyz * m_LightIntensityArray[i]);
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
				
				//float3 l_Normal=normalize(IN.WorldNormal);
				
				float l_DiffuseContrib=max(0.0, dot(bumpNormal, lightDirection));
				
				float3 l_HalfWayVector=normalize(normalize(m_CameraPosition-IN.WorldPos)+lightDirection);
				float l_SpecularContrib=pow(max(0, dot(l_HalfWayVector, bumpNormal)), l_SpecularPower);
				
				l_DiffuseLight+=(l_DiffuseContrib * m_LightColor[i].xyz * l_Texture.xyz * m_LightIntensityArray[i] * l_Attenuation * l_SpotAttenuation);
				
				l_SpecularLight+=(l_SpecularContrib * m_LightColor[i].xyz * m_LightIntensityArray[i] * l_Attenuation * l_SpotAttenuation); 
			}
		}
	}
	
	float4 l_Light = (clamp(float3(l_AmbientLight),0,1) + clamp(float3(l_SpecularLight),0,1) + clamp(float3(l_DiffuseLight),0,1), l_Texture.a);
	//return float4(bumpNormal,1.0);
	return l_Light;
}