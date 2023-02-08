
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
Texture2D<float4> Texture0 : register(t0);
sampler Texture0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fA;
	float fB;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    float ScreenX = (fA+(fB-fA)*In.texCoord.y)/2;
    ScreenX = (ScreenX+In.texCoord.x-0.5)/ScreenX/2;
    
    if(ScreenX >= 0 && ScreenX <= 1)
    	Out.Color = Texture0.Sample(Texture0Sampler,float2(ScreenX,In.texCoord.y));
    else Out.Color = float4(0,0,0,0);
    
	Out.Color *= In.Tint;
    return Out;
}
