struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float width;
	float height;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 shift = img.Sample(imgSampler,In.texCoord);
	float2 off = float2(width*fPixelWidth,height*fPixelHeight);
	off.x *= 2*(shift.r-0.5);
	off.y *= 2*(shift.g-0.5);
	float4 o = bg.Sample(bgSampler,In.texCoord+off);
	o += bg.Sample(bgSampler,In.texCoord+off+float2(fPixelWidth*0.5,0));
	o += bg.Sample(bgSampler,In.texCoord+off+float2(fPixelWidth*-0.5,0));
	o += bg.Sample(bgSampler,In.texCoord+off+float2(0,fPixelHeight*0.5));
	o += bg.Sample(bgSampler,In.texCoord+off+float2(0,fPixelHeight*-0.5));
	o /= 5;
	return o;
}
