
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
	float4 r;
	float4 g;
	float4 b;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 i = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float4 o = float4(0,0,0,i.a);
	o.rgb = r.rgb*i.r + g.rgb*i.g + b.rgb*i.b;	
	return o;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 i = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( i.a != 0 )
		i.rgb /= i.a;
	float4 o = float4(0,0,0,i.a);
	o.rgb = r.rgb*i.r + g.rgb*i.g + b.rgb*i.b;
	o.rgb *= o.a;
	return o;
}
