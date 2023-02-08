
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float Intensity;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET	{
	float4 srcPixel = Demultiply(img.Sample(imgSampler,In.texCoord));
	float4 bgPixel = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
	float fGrey = dot(bgPixel.rgb, float3(0.3, 0.59, 0.11));
 	bgPixel.rgb = lerp(fGrey, bgPixel.rgb, (srcPixel.r+srcPixel.g+srcPixel.b) * Intensity / 3.0).rgb;
	//bgPixel.a = srcPixel.a;	
	return bgPixel * In.Tint;
}

