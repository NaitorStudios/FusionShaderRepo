// Global variables
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> fg : register(t0);
sampler fgSampler : register(s0);

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);


float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 src = fg.Sample(fgSampler,In.texCoord) * In.Tint;
	float3 inv = 1.0-src.rgb;
	float4 bck = bg.Sample(bgSampler,In.texCoord);
	//Blend between src and inv based on |fore-back|
	return float4(inv+(src.rgb-inv)*abs(src.rgb-bck.rgb),src.a);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 src = fg.Sample(fgSampler,In.texCoord) * In.Tint;
	if ( src.a != 0 )
		src.rgb /= src.a;
	float3 inv = 1.0-src.rgb;
	float4 bck = bg.Sample(bgSampler,In.texCoord);
	//Blend between src and inv based on |fore-back|
	return float4((inv+(src.rgb-inv)*abs(src.rgb-bck.rgb))*src.a,src.a);
}
