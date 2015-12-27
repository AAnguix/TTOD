//https://msdn.microsoft.com/en-us/library/windows/desktop/ff471376(v=vs.85).aspx

//Texture
texture OmniLightTexture  <
string ResourceName = "";//Optional default file name
string UIName =  "OmniLightTexture Texture";
string ResourceType = "2D";
>;

sampler2D OmniLightTextureSampler = sampler_state 
{
Texture = <OmniLightTexture>;
MinFilter = Linear;
MagFilter = Linear;
MipFilter = Linear;
AddressU = Wrap;
AddressV = Wrap;
};

//Lights
float3 Lamp0Point : POSITION
<
string Object = "Point Light 0";
string UIName =  "Lamp 0 Position";
string Space = "World";
> = {-0.5f,2.0f,1.25f};

float3 Lamp_0_color : COLOR <
string Object = "Point Light 0";
string UIName =  "Lamp 0 Color";
string UIWidget = "Color";
> = {0.6f,0.8f,1.0f};
	
float4 LampAmbientLight : COLOR
<
string UIWidget = "Color";
string UIName =  "Lamp_AmbientLight";
>  = {0.2f, 0.2f, 0.2f, 1.0f};

//Sliders
float g_OmniLightIntensity
<
string UIWidget = "slider";
float UIMin = 0.0;
float UIMax = 3.0;
float UIStep = 0.1;
string UIName =  "g_LightIntensity";
> = 1.0;

float g_SpecularPower
<
string UIWidget = "slider";
float UIMin = 10.0;
float UIMax = 100.0;
float UIStep = 0.01;
string UIName =  "g_SpecularPower";
> = 1;

float g_Start
<
string UIWidget = "slider";
float UIMin = 5.0;
float UIMax = 30.0;
float UIStep = 0.01;
string UIName =  "g_Start";	
> = 0.5;
		
float g_End
<
string UIWidget = "slider";
float UIMin = 50.0;
float UIMax = 100.0;
float UIStep = 0.01;
string UIName =  "g_End";
> = 0.5;
	  
float4x4 View : View;
float4x4 ViewInverse : ViewInverse;
float4x4 World : World;
float4x4 Projection : Projection;

struct TVertexVS
{
	float3 Pos : POSITION;
	float3 Normal : NORMAL;
	float2 UV : TEXCOORD0;
};

struct TVertexPS
{
	float4 Pos : POSITION;
	float3 Normal : NORMAL;
	float2 UV : TEXCOORD0;
	float3 WorldPosition: TEXCOORD1;
};

TVertexPS mainVS(TVertexVS IN) 
{  
	TVertexPS l_Out=(TVertexPS)0;  
	l_Out.Pos=mul(float4(IN.Pos.xyz, 1.0), World);  
	l_Out.WorldPosition=l_Out.Pos.xyz;
	l_Out.Pos=mul(l_Out.Pos, View);  
	l_Out.Pos=mul(l_Out.Pos, Projection);  
	l_Out.Normal=normalize(mul(IN.Normal, (float3x3)World));  
	
	l_Out.UV=IN.UV; 
	//Las coordenadas de textura las pasamos al PS conforme las recibimos
	return l_Out; 
} 

float4 mainPS(TVertexPS IN) : COLOR 
{  
	//Luz ambiente + Luz Difusa + Luz Specular=>
	//luz ambiente = Color luz ambiente * Textura
	//luz difusa = DiffuseContrib * Light Color * Textura * Light intensity * Attenuation
	//luz specular = SpecularContrib * Light Color * Light intensity * Attenuation
	
	float3 lightDirection = Lamp0Point - IN.WorldPosition; //Punto final - Punto inicio
	float l_Distance=length(lightDirection);
	float l_Attenuation = 1 - saturate((l_Distance-g_Start)/(g_End-g_Start));
	lightDirection/=l_Distance; //Normalize

	float3 l_CameraPosition=ViewInverse[3].xyz;
		
	float3 l_Normal=normalize(IN.Normal);
	
	float l_DiffuseContrib=max(0.0, dot(l_Normal, lightDirection));
	
	float3 l_HalfWayVector=normalize(normalize(l_CameraPosition-IN.WorldPosition)+lightDirection);
	float l_SpecularContrib=pow(max(0, dot(l_HalfWayVector, l_Normal)), g_SpecularPower);
	
	float4 l_Texture=tex2D(OmniLightTextureSampler , IN.UV); //Color textura
	
	//Cálculo luces
	float3 l_AmbientLight=l_Texture.xyz*LampAmbientLight.xyz;
	
	float3 l_DiffuseLight=l_DiffuseContrib*Lamp_0_color.xyz*l_Texture.xyz*g_OmniLightIntensity*l_Attenuation;
	
	float3 l_SpecularLight=l_SpecularContrib * Lamp_0_color.xyz * g_OmniLightIntensity * l_Attenuation; 
	//l_SpecularLight=float3(0,0,0);
	return float4(l_AmbientLight+l_SpecularLight+l_DiffuseLight, l_Texture.a);	
}

technique technique0 
{
	pass p0 
	{
		CullMode = None;
		VertexShader = compile vs_3_0 mainVS();
		PixelShader = compile ps_3_0 mainPS();
	}
}
