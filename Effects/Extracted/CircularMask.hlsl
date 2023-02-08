
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float x;
	float y;
	float r;
	int s;
	int i;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 ret = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float tmp = sqrt(pow(In.texCoord.x/fPixelWidth-x,2)+pow(In.texCoord.y/fPixelHeight-y,2))/r;
	tmp = pow(abs(tmp),s);
	ret.a *= i?1-tmp:tmp;
	return ret;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 ret = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float tmp = sqrt(pow(In.texCoord.x/fPixelWidth-x,2)+pow(In.texCoord.y/fPixelHeight-y,2))/r;
	tmp = pow(abs(tmp),s);
	ret.a *= i?1-tmp:tmp;
	if ( ret.a <= 1 )
		ret.rgb *= i?1-tmp:tmp;
	return ret;
}
