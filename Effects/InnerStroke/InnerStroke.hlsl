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
	float4 sColor;
	float size, fOpacity;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	// get color of pixels:
	float4 color = Demultiply(img.Sample( imgSampler, In.texCoord )) * In.Tint;
	float alpha = 4 * color.a * In.Tint.a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( size * fPixelWidth, 0.0f ) ).a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( -size * fPixelWidth, 0.0f ) ).a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( 0.0f, size * fPixelHeight ) ).a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( 0.0f, -size * fPixelHeight ) ).a;

	// calculate resulting color
	color.a = lerp(0.0, color.a, fOpacity);
	if (alpha > 0)
	{
		color = float4(sColor.rgb, alpha );
	}
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	// get color of pixels:
	float4 color = Demultiply(img.Sample( imgSampler, In.texCoord )) * In.Tint;
	float alpha = 4 * color.a * In.Tint.a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( size * fPixelWidth, 0.0f ) ).a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( -size * fPixelWidth, 0.0f ) ).a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( 0.0f, size * fPixelHeight ) ).a;
	alpha -= img.Sample( imgSampler, In.texCoord + float2( 0.0f, -size * fPixelHeight ) ).a;

	// calculate resulting color
	color.a = lerp(0.0, color.a, fOpacity);
	if (alpha > 0)
	{
		color = float4(sColor.rgb, alpha );
	}
	color.rgb *= color.a;
	return color;
}


