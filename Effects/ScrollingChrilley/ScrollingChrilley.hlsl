
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

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

float fScrollX = 1.0;
float fScrollY = 1.0;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = bkd.Sample(bkdSampler, float2(In.texCoord.x+fScrollX,In.texCoord.y+fScrollY));
	
    return Out;
}

