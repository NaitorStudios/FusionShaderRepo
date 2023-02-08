Texture2D<float4> timg : register(t0);
sampler simg : register(s0);

Texture2D<float4> tpal : register(t1);
sampler spal : register(s1);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
  float4 SrcPixel = timg.Sample(simg, In.texCoord);
  uint Index = 255.0 * SrcPixel.r;
  float2 samplePos;
  samplePos.x = (Index % 16) * 0.0625;
  samplePos.y = (Index / 16) * 0.0625;
  SrcPixel = tpal.Sample(spal, samplePos);
  SrcPixel *= In.Tint;
  return SrcPixel;
}