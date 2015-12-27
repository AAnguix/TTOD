//https://msdn.microsoft.com/en-us/library/windows/desktop/ff471376(v=vs.85).aspx

//Lights
float3 Lamp0Direction : DIRECTION
<
string Object = "Directional Light 0";
string UIName =  "Lamp 0 Direction";
string Space = "World";
> = {-0.5f,2.0f,1.25f};

float3 Lamp_0_color : COLOR <
string Object = "Directional Light 0";
string UIName =  "Lamp 0 Color";
string UIWidget = "Color";
> = {0.0f,0.1f,1.0f};
	
float4 Lamp_AmbientLight : COLOR
<
string UIWidget = "Color";
string UIName =  "Lamp_AmbientLight";
>  = {0.8f, 0.8f, 0.8f, 1.0f};



float g_LightIntensity
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
	


//Textures
Texture2D shaderTexture;
SamplerState sampleType;

sampler textureSampler  = sampler_state
{ 
    Texture = (shaderTexture);
    MipFilter = LINEAR; 
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};
	  
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
	//luz ambiente = Color luz ambiente * Albedo
	//luz difusa = DiffuseContrib * Light Color * Albedo * Light intensity * Attenuation
	//luz specular = SpecularContrib * Light Color * Light intensity * Attenuation
	float3 l_CameraPosition=ViewInverse[3].xyz;
	float3 Hn=normalize(normalize(l_CameraPosition-IN.WorldPosition)-Lamp0Direction);	
	float3 Nn=normalize(IN.Normal);
	float l_DiffuseContrib=max(0.0, dot(Nn, -Lamp0Direction))*g_LightIntensity;
	float l_SpecularContrib=pow(max(0, dot(Hn, Nn)), g_SpecularPower)*g_LightIntensity;
	float4 l_Albedo=tex2D(textureSampler , IN.UV); //Color textura
	return float4(l_Albedo.xyz*Lamp_AmbientLight.xyz+l_DiffuseContrib*Lamp_0_color.xyz*l_Albedo.xyz+l_SpecularContrib*Lamp_0_color.xyz, l_Albedo.a);	
}

technique technique0 {
	pass p0 {
		CullMode = None;
		VertexShader = compile vs_3_0 mainVS();
		PixelShader = compile ps_3_0 mainPS();
	}
}
	