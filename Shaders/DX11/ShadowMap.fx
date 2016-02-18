/*Used to generate the shadowmap*/

#include "globals.fxh"
#include "functions.fxh"
#include "samplers.fxh"

//--------------------------------------------------------------------------------------
struct VS_INPUT
{
	float3 Pos : POSITION;
};

struct PS_INPUT
{
	float4 Pos : SV_POSITION;
	float4 Depth : TEXCOORD0;
};

PS_INPUT VS(VS_INPUT IN)
{
	PS_INPUT l_Out=(PS_INPUT)0;
	l_Out.Pos=mul(float4(IN.Pos.xyz, 1.0), m_World);
	l_Out.Pos=mul(l_Out.Pos, m_View);
	l_Out.Pos=mul(l_Out.Pos, m_Projection);
	l_Out.Depth=l_Out.Pos;
	return l_Out;
}

float4 PS(PS_INPUT IN) : SV_Target
{
	// float4 l_Color=float4(0,0,0,0);
	// #if HAS_COLOR
		// l_Color=float4(1,0,0,1);
	// #endif


	float l_Depth=IN.Depth.z/IN.Depth.w;
	return float4(l_Depth,l_Depth,l_Depth,1);
	//Distance from pixel to the light
}