
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{

	float strength;

};


//Ported from this: https://www.shadertoy.com/view/4dKBDR

float2 rand( float2  p ) { p = float2( dot(p,float2(127.1,311.7)), dot(p,float2(269.5,183.3)) ); return frac(sin(p)*43758.5453); }

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float2 uv = In.texCoord;
    
    return Tex0.Sample( Tex0Sampler, uv + strength*(rand(uv)-0.5)) * In.Tint;
}
