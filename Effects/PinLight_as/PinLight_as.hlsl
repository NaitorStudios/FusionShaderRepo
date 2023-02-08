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


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord));
	float4 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
	float4 O = (L<0.5)?min(B,(2.0*L)):max(B,(2.0*(L-0.5)));
	color.rgb = O.rgb;
	color.a= L.a;

	return color * In.Tint;
}


float4 ps_main_pm(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord));
	float4 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
	float4 O = ((L<0.5)?min(B,(2.0*L)):max(B,(2.0*(L-0.5))));
	color.rgb = O.rgb;
	color.a= L.a;
	color.rgb *= color.a;

	return color * In.Tint;
}
