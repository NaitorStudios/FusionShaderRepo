Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	return max(img.Sample(imgSampler,In.texCoord) * In.Tint, bkd.Sample(bkdSampler,In.texCoord));
}
