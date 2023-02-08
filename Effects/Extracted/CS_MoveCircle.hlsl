
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
	float fTimer;
	float fPowerX;
	float fPowerY;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
    In.texCoord.y = In.texCoord.y + (sin(fTimer)*fPowerY);
    In.texCoord.x = In.texCoord.x + (cos(fTimer)*fPowerX);
   	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord.xy);
	Out.Color *= In.Tint;
	
    return Out;
}

