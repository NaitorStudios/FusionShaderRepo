struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};


Texture2D<float4> Img : register(t0);
sampler ImgSampler : register(s0);

Texture2D<float4> Alpha : register(t1);
sampler AlphaSampler : register(s1);


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 SrcPixel = Demultiply(Img.Sample(ImgSampler, In.texCoord) * In.Tint);
	SrcPixel.a = Alpha.Sample(AlphaSampler, In.texCoord).r * SrcPixel.a;
	return SrcPixel;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 SrcPixel = Demultiply(Img.Sample(ImgSampler, In.texCoord) * In.Tint);
	SrcPixel.a = Alpha.Sample(AlphaSampler, In.texCoord).r * SrcPixel.a;
	SrcPixel.rgb *= SrcPixel.a;
	return SrcPixel;
}

