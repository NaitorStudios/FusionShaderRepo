
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

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
	float4 f4 = Out.Color * float4(0.0f, 0.0f, 1.0f, 1.0f);
	//float f = f4.r + f4.g + f4.b;
	Out.Color.rgb = f4.rgb;

    return Out;
}
