struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> fg : register(t0);
sampler fgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float x;
	float y;
	int limit;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 color = 0.0;
	float2 pos = float2(x,y);
	if(limit)
		pos -= floor(pos);
	pos = In.texCoord-pos*float2(fPixelWidth,fPixelHeight);
	if(pos.x>=0&&pos.x<=1&&pos.y>=0&&pos.y<=1)
		color = fg.Sample(fgSampler,pos) * In.Tint;
	return color;
}
