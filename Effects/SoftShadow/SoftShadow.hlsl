// Soft Shadow
// v1.0
// By asker

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
    float4 shadowColor;
    float opacity;
    float offsetX;
    float offsetY;
    float sampleDistance;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

static const int SHADOW_ITERATIONS = 24;
static const float ANGLE_INCREASE = 6.28318530717 / SHADOW_ITERATIONS;

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 ps_main(PS_INPUT In) : SV_TARGET
{
    float2 pixelCorrection = float2(fPixelWidth, fPixelHeight);
    float4 p = img.Sample(imgSampler, In.texCoord);
    float2 pos = In.texCoord - float2(offsetX, offsetY) * pixelCorrection;
    float shadowIntensity = 0.0;
    for(int i = 0; i < SHADOW_ITERATIONS; i++) {
        shadowIntensity += img.Sample(imgSampler, pos + float2(cos(i * ANGLE_INCREASE), sin(i * ANGLE_INCREASE)) * sampleDistance * pixelCorrection).a;
    }
    float shadowAlpha = shadowIntensity * opacity / SHADOW_ITERATIONS;
    //Multiply shadowColor with its shadowAlpha to make it premultiplied
    float4 color = float4(p.rgb + shadowColor.rgb * shadowAlpha * (1.0 - p.a), p.a + shadowAlpha * (1.0 - p.a));
    //Demultiply colors back to RGB space
    return Demultiply(color) * In.Tint;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
    float2 pixelCorrection = float2(fPixelWidth, fPixelHeight);
    float4 p = img.Sample(imgSampler, In.texCoord);
    float2 pos = In.texCoord - float2(offsetX, offsetY) * pixelCorrection;
    float shadowIntensity = 0.0;
    for(int i = 0; i < SHADOW_ITERATIONS; i++) {
        shadowIntensity += img.Sample(imgSampler, pos + float2(cos(i * ANGLE_INCREASE), sin(i * ANGLE_INCREASE)) * sampleDistance * pixelCorrection).a;
    }
    float shadowAlpha = shadowIntensity * opacity / SHADOW_ITERATIONS;
    //Multiply shadowColor with its shadowAlpha to make it premultiplied
    float4 color = float4(p.rgb + shadowColor.rgb * shadowAlpha * (1.0 - p.a), p.a + shadowAlpha * (1.0 - p.a));
    return color * In.Tint;
}