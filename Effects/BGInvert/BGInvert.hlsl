
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

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{ 
	float4 o = img.Sample(imgSampler,In.texCoord) * In.Tint;
	o.rgb = 1.0-bkd.Sample(bkdSampler,In.texCoord).rgb;
	return o;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{ 
	float4 o = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( o.a != 0 )
		o.rgb /= o.a;
	float4 bk = bkd.Sample(bkdSampler,In.texCoord); 
	if ( bk.a != 0 )
		bk.rgb /= bk.a;
	o.rgb = 1.0 - bk.rgb;
	o.rgb *= o.a;
	return o;
}