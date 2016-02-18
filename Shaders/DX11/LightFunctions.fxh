/*Light Calculations*/

float GetOmniDiffuseContrib( float3 NormalNormalized, float3 LightDirectionCalc)
{
	return max(0.0, dot(NormalNormalized, LightDirectionCalc));
}
float GetOmniSpecularContrib( float3 NormalNormalized, float4 CameraPosition, float3 WorldPos, float3 LightDirectionCalc, float SpecularPower)
{
	float3 l_HalfWayVector = normalize(normalize(CameraPosition.xyz-WorldPos) + LightDirectionCalc);
	float l_SpecularContrib = pow(max(0, dot(l_HalfWayVector, NormalNormalized)), SpecularPower);
	return l_SpecularContrib;
}

float GetDirectionalDiffuseContrib( float3 NormalNormalized, float4 LightDirection)
{
	return max(0.0, dot(NormalNormalized, -LightDirection.xyz));
}
float GetDirectionalSpecularContrib( float3 NormalNormalized, float4 CameraPosition, float3 WorldPos, float4 LightDirection, float SpecularPower)
{
	float3 l_HalfWayVector = normalize(normalize(CameraPosition.xyz - WorldPos) - LightDirection.xyz);	
	return pow(max(0, dot(l_HalfWayVector, NormalNormalized)), SpecularPower);
}

float GetSpotDiffuseContrib( float3 NormalNormalized, float3 LightDirectionCalc)
{
	return max(0.0, dot(NormalNormalized, LightDirectionCalc));
}
float GetSpotSpecularContrib( float3 NormalNormalized, float4 CameraPosition, float3 WorldPos, float3 LightDirectionCalc, float SpecularPower)
{
	float3 l_HalfWayVector=normalize(normalize(CameraPosition.xyz - WorldPos)+LightDirectionCalc);
	return pow(max(0, dot(l_HalfWayVector, NormalNormalized)), SpecularPower);
}
float GetSpotAttenuation( float Angle, float FallOffAngle, float3 LightDirectionCalc, float4 LightDirection)
{
	float l_CosAngle = cos(Angle*0.5*3.1416/180.0);
	float l_CosFallOff = cos(FallOffAngle*0.5*3.1416/180.0);
	float l_DotLight = dot(LightDirectionCalc, -LightDirection.xyz);
	return float(saturate((l_DotLight-l_CosFallOff)/(l_CosAngle-l_CosFallOff)));
}

float GetAttenuation( float Distance, float AttenuationStartRange, float AttenuationEndRange)
{
	return float(1 - saturate((Distance-AttenuationStartRange)/(AttenuationEndRange-AttenuationStartRange)));
}

float4 GetLightsSummation( float3 Ambient,  float3 Diffuse, float3 Specular, float Alpha)
{
	return float4 ( clamp(float3(Ambient),0,1) + clamp(float3(Diffuse),0,1) + clamp(float3(Specular),0,1), Alpha );
}	

float4 GetLightsSummation( float3 Diffuse, float3 Specular, float Alpha)
{
	return float4 ( clamp(float3(Diffuse),0,1) + clamp(float3(Specular),0,1), Alpha );
}

void GetSingleIluminatedPixelColor(int IdLight, float4 DiffuseTexture, float SpecularPower, float3 WorldPos, float3 Nn, out float3 DiffuseLight, out float3 SpecularLight, float ShadowMapContrib)
{
	DiffuseLight = float3(0.0,0.0,0.0);
	SpecularLight = float3(0.0,0.0,0.0);
	
	if(m_LightEnabledArray[IdLight]) //Enabled
	{
		if(m_LightTypeArray[IdLight]==0.0f) //OMNI
		{
			float3 lightDirection = m_LightPosition[IdLight].xyz - WorldPos; //Punto final - Punto inicio
			float l_Distance=length(lightDirection);
			float l_Attenuation =  GetAttenuation( l_Distance, m_LightAttenuationStartRangeArray[IdLight], m_LightAttenuationEndRangeArray[IdLight]);
			lightDirection/=l_Distance; //Normalize
			
			float l_DiffuseContrib = GetOmniDiffuseContrib(Nn,lightDirection);
			
			float l_SpecularContrib = GetOmniSpecularContrib(Nn,m_CameraPosition,WorldPos,lightDirection,SpecularPower);
			
			DiffuseLight=(l_DiffuseContrib * m_LightColor[IdLight].xyz * DiffuseTexture.xyz * m_LightIntensityArray[IdLight] * l_Attenuation);
			
			SpecularLight=(l_SpecularContrib * m_LightColor[IdLight].xyz * m_LightIntensityArray[IdLight] * l_Attenuation); 
		}
		else if(m_LightTypeArray[IdLight]==1.0f) //DIRECTIONAL
		{
			float l_DiffuseContrib = GetDirectionalDiffuseContrib(Nn,m_LightDirection[IdLight]);
			
			float l_SpecularContrib = GetDirectionalSpecularContrib(Nn,m_CameraPosition,WorldPos,m_LightDirection[IdLight],SpecularPower);
			
			DiffuseLight=(l_DiffuseContrib * m_LightColor[IdLight].xyz * DiffuseTexture.xyz * m_LightIntensityArray[IdLight]);
			
			SpecularLight=(l_SpecularContrib *  m_LightColor[IdLight].xyz * m_LightIntensityArray[IdLight]);
		}
		else if(m_LightTypeArray[IdLight]==2.0f) //SPOT
		{
			float3 lightDirection = m_LightPosition[IdLight].xyz - WorldPos; //Punto final - Punto inicio
			float l_Distance=length(lightDirection);
			float l_Attenuation =  GetAttenuation( l_Distance, m_LightAttenuationStartRangeArray[IdLight], m_LightAttenuationEndRangeArray[IdLight]);
			lightDirection/=l_Distance; //Normalize
			
			float l_SpotAttenuation =  GetSpotAttenuation(m_LightAngleArray[IdLight],m_LightFallOffAngleArray[IdLight],lightDirection,m_LightDirection[IdLight]);
			
			float l_DiffuseContrib = GetSpotDiffuseContrib(Nn,lightDirection);
			
			float l_SpecularContrib = GetSpotSpecularContrib(Nn,m_CameraPosition,WorldPos,lightDirection,SpecularPower);
			
			DiffuseLight=(l_DiffuseContrib * m_LightColor[IdLight].xyz * DiffuseTexture.xyz * m_LightIntensityArray[IdLight] * l_Attenuation * l_SpotAttenuation);
			
			SpecularLight=(l_SpecularContrib * m_LightColor[IdLight].xyz * m_LightIntensityArray[IdLight] * l_Attenuation * l_SpotAttenuation); 
		}
	}
	DiffuseLight*=ShadowMapContrib;
	SpecularLight*=ShadowMapContrib;
}

float3 GetIluminatedPixelColor( float4 DiffuseTexture, float SpecularPower, float3 WorldPos, float3 WorldNormal, float4 AmbientLight, int NumLights)
{
	float3 l_AmbientLight = (DiffuseTexture.xyz*AmbientLight.xyz);
	float3 l_AccDiffuseLight = float3(0.0,0.0,0.0);
	float3 l_AccSpecularLight = float3(0.0,0.0,0.0);
	
	float3 Nn=normalize(WorldNormal);
	for(int i=0;i<NumLights;++i)
	{ 
		float3 l_DiffuseLight = float3(0.0,0.0,0.0);
		float3 l_SpecularLight = float3(0.0,0.0,0.0);
		GetSingleIluminatedPixelColor(i, DiffuseTexture, SpecularPower, WorldPos, Nn, l_DiffuseLight, l_SpecularLight,1.0f);
		l_AccDiffuseLight+=l_DiffuseLight;
		l_AccSpecularLight+=l_SpecularLight;
	}
	return l_AmbientLight+l_AccDiffuseLight+l_AccSpecularLight;
}

float GetShadowMapContrib(int IdLight, float3 WorldPos, Texture2D ShadowMapTexture, SamplerState Sampler)
{
	float l_ShadowContrib=1.0f;
	
	if(m_UseShadowMapArray[IdLight])
	{
		float4 l_LightViewPosition=mul(float4(WorldPos, 1), m_LightView[IdLight]);
		l_LightViewPosition=mul(l_LightViewPosition, m_LightProjection[IdLight]);
		
		float2 l_ProjectedLightCoords=float2(((l_LightViewPosition.x/l_LightViewPosition.w)/2.0f)+0.5f, ((-l_LightViewPosition.y/l_LightViewPosition.w)/2.0f)+0.5f);
		
		float l_DepthShadowMap=ShadowMapTexture.Sample(Sampler, l_ProjectedLightCoords).r;
		float l_LightDepth=l_LightViewPosition.z/l_LightViewPosition.w;
		float m_ShadowMapBias=0.001;
		l_DepthShadowMap=l_DepthShadowMap+m_ShadowMapBias;
		float m_ShadowMapStrength=0;
		if((saturate(l_ProjectedLightCoords.x)==l_ProjectedLightCoords.x) && (saturate(l_ProjectedLightCoords.y)==l_ProjectedLightCoords.y))
		{
			if(l_LightDepth>l_DepthShadowMap)
				l_ShadowContrib=m_ShadowMapStrength;
		}
	}
	return l_ShadowContrib;
}