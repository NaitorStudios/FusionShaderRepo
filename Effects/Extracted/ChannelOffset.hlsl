
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
	float Rx;
	float Ry;
	float Gx;
	float Gy;
	float Bx;
	float By;
	float Ax;
	float Ay;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 texClip(Texture2D<float4> img, sampler imgSampler, float2 pos, float4 tint)
{
	return (pos.x < 0 || pos.y < 0 || pos.x > 1 || pos.y > 1) ? 0 : img.Sample(imgSampler,pos) * tint;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float2 Pixel = float2(fPixelWidth,fPixelHeight);

	color.r = texClip(img,imgSampler,In.texCoord+Pixel*float2(Rx,Ry), In.Tint).r;
	color.g = texClip(img,imgSampler,In.texCoord+Pixel*float2(Gx,Gy), In.Tint).g;
	color.b = texClip(img,imgSampler,In.texCoord+Pixel*float2(Bx,By), In.Tint).b;
	color.a = texClip(img,imgSampler,In.texCoord+Pixel*float2(Ax,Ay), In.Tint).a;

	return color;
}

float4 texClip_pm(Texture2D<float4> img, sampler imgSampler, float2 pos, float4 tint)
{
	if (pos.x < 0 || pos.y < 0 || pos.x > 1 || pos.y > 1)
		return 0;
	float4 color = img.Sample(imgSampler,pos) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	float2 Pixel = float2(fPixelWidth,fPixelHeight);

	color.r = texClip_pm(img,imgSampler,In.texCoord+Pixel*float2(Rx,Ry), In.Tint).r;
	color.g = texClip_pm(img,imgSampler,In.texCoord+Pixel*float2(Gx,Gy), In.Tint).g;
	color.b = texClip_pm(img,imgSampler,In.texCoord+Pixel*float2(Bx,By), In.Tint).b;
	color.a = texClip_pm(img,imgSampler,In.texCoord+Pixel*float2(Ax,Ay), In.Tint).a;

	color.rgb *= color.a;
	return color;
}
