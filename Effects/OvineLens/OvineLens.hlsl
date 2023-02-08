// Author: Looki
// Modified by AndyH@Ovine.net
// Ported to dx11 by Emil Macko
Texture2D<float4> Lens : register(t1);
sampler LensSampler : register(s1);
Texture2D<float4> img;
sampler imgSampler;

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
	float fCoeff, fBase;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float height = fBase + Lens.Sample(LensSampler, In.texCoord).r * fCoeff;
	In.texCoord += (height - 1.0f) / 2.0;
	return img.Sample(imgSampler, In.texCoord / height);
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if(color.a != 0) color.rgb /= color.a;
	return color;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float height = fBase + Demultiply(Lens.Sample(LensSampler, In.texCoord)).r * fCoeff;
	In.texCoord += (height - 1.0f) / 2.0;
	return img.Sample(imgSampler, In.texCoord / height);
}