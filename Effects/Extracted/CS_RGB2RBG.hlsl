
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
    PS_OUTPUT Def;
    PS_OUTPUT Out;

	Def.Color = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
	Out.Color.r = Def.Color.r;
	Out.Color.b = Def.Color.g;
	Out.Color.g = Def.Color.b;

    return Out;
}

