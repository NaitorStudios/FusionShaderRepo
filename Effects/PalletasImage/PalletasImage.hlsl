
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> pal : register(t1);
sampler palSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	int roffset;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	float4 o = img.Sample(imgSampler, In.texCoord);
	int palletindex = (255.0 * o.r) - roffset;
	In.texCoord.x = 0.03125 * (float(palletindex) % 32);
	In.texCoord.y = 0.03125 * (float(palletindex) / 32);
	o.rgb = pal.Sample(palSampler, In.texCoord).rgb;
	return o;
}
