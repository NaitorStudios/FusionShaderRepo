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
	float coeff;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
    return color * float4(1,1,1,coeff);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
    return color * coeff;
}
