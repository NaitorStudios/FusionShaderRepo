
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
	float rr;
	float rg;
	float rb;
	float gr;
	float gg;
	float gb;
	float br;
	float bg;
	float bb;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 a = img.Sample(imgSampler, In.texCoord) * In.Tint;
	float4 i = bkd.Sample(bkdSampler, In.texCoord);
	float4 o = 1.0;
	o.rgb = float3(rr, rg, rb)*i.r + float3(gr, gg, gb)*i.g + float3(br, bg, bb)*i.b;	
	o.rgb = lerp(i.rgb, o.rgb, a.rgb);
	return o;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float4 a = img.Sample(imgSampler, In.texCoord) * In.Tint;
	if ( a.a != 0 )
		a.rgb /= a.a;
	float4 i = bkd.Sample(bkdSampler, In.texCoord);
	if ( i.a != 0 )
		i.rgb /= i.a;
	float4 o = 1.0;
	o.rgb = float3(rr, rg, rb)*i.r + float3(gr, gg, gb)*i.g + float3(br, bg, bb)*i.b;	
	o.rgb = lerp(i.rgb, o.rgb, a.rgb);
	o.rgb *= o.a;
	return o;
}
