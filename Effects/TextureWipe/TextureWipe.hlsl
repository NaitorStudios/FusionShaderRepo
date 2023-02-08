
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);
Texture2D<float4> mask : register(t2);
sampler maskSampler : register(s2);

cbuffer PS_VARIABLES : register(b0)
{
	uniform float p;
	bool alphaWipe;
	uniform float4 cWipe;
	bool useHalo;
	uniform float4 cHalo;
	uniform float ramp;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 alpha_composite(float4 top, float4 bottom) {
    float alpha = top.a + bottom.a * (1.0 - top.a);
    return float4((top.rgb * top.a + bottom.rgb * (bottom.a * (1.0 - top.a))) / alpha, alpha);
}


float4 ps_main(PS_INPUT In) : SV_TARGET
{
	float _ramp = max(ramp,0.0001);
	float4 Out;
    float4 before_pixel = (Tex0.Sample(Tex0Sampler, In.texCoord));
    float4 after_pixel = alphaWipe ? bkd.Sample(bkdSampler, In.texCoord) : cWipe;
    float4 mask_pixel = mask.Sample(maskSampler, In.texCoord);
    float discriminator = mask_pixel.r + mask_pixel.g / 256.0 + mask_pixel.b / 65536.0;
    float scaled_t = p * (1.0 + _ramp * 2.0) - _ramp;
	float alpha;
    if (useHalo) {
        // Compute the alpha of the halo such that it's 1.0 when the
        // discriminator matches exactly, and 0.0 just at the end of the ramp
        alpha = clamp(1.0 - abs(scaled_t - discriminator) / _ramp, 0.0, 1.0);
		float new_a = 1-(1-alpha)*(1-before_pixel.a);
		alpha = (alpha*before_pixel.a*(alpha))/new_a;

        float4 halo = float4(cHalo.rgb, alpha);
        if (scaled_t < discriminator) {
            Out = alpha_composite(halo, before_pixel);
        }
        else {
            Out = alpha_composite(halo, after_pixel);
        }
    }
    else {
		float alpha = clamp((scaled_t - discriminator) / _ramp + 0.5, 0.0, 1.0);
        after_pixel.a *= alpha;
        Out = alpha_composite(after_pixel, before_pixel);
    }
	
	return Out;
	//float3 test = clamp(before_pixel.a,0.0,1.0);
	//return float4(test,1.0);
}

