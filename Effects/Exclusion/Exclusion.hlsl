Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float3 L = img.Sample(imgSampler,In.texCoord).rgb * In.Tint.rgb;
	float3 B = bkd.Sample(bkdSampler,In.texCoord).rgb;
	float4 O = 1.0;
	O.rgb = B+L-2.0*B*L;
	return O;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float3 L = Demultiply(img.Sample(imgSampler,In.texCoord) * In.Tint).rgb;
	float3 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord)).rgb;
	float4 O = 1.0;
	O.rgb = B+L-2.0*B*L;
	return O;
}
