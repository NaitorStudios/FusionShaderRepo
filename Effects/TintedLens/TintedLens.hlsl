struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> tex0 : register(t0);
sampler tex0Sampler : register(s0);

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float4 tintColor;
	float tintPow;
	float tintOrigPow;
	float lensBase;
	float lensCoeff;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    float height = lensBase + tex0.Sample(tex0Sampler,In.texCoord).r * In.Tint.r * lensCoeff;
    In.texCoord += (height - 1.0f) / 2.0f;
    
    float4 col = bg.Sample(bgSampler, In.texCoord / height);
    col.rgb = col.rgb*tintOrigPow + col.rgb*tintColor*tintPow;   
    return col;
}
