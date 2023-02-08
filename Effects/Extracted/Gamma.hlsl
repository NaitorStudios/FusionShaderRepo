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
	float factor;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 o = img.Sample(imgSampler,In.texCoord) * In.Tint;
	o.rgb = lerp(o.rgb,sin(o.rgb*3.14159),factor);
	return o;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 o = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( o.a != 0 )
		o.rgb /= o.a;
	o.rgb = lerp(o.rgb,sin(o.rgb*3.14159),factor);
	o.rgb *= o.a;
	return o;
}
