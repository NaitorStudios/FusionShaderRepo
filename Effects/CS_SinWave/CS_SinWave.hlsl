struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color : SV_TARGET;
};

// Global variables
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fAmplitude;
	float fPeriods;
	float fFreq;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	In.texCoord.y = In.texCoord.y + (sin((In.texCoord.x+fFreq)*fPeriods)*fAmplitude);
	Out.Color = Texture0.Sample(TextureSampler0, In.texCoord.xy) * In.Tint;

    return Out;
}
