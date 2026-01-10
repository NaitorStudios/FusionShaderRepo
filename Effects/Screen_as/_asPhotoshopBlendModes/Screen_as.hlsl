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
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord)) * In.Tint;
	float4 B = bkd.Sample(bkdSampler,In.texCoord);
	color.rgb = 1.0-((1.0-B.rgb)*(1.0-L.rgb));
	color.a= L.a;

	return color;
}

float4 ps_main_pm(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord)) * In.Tint;
	float4 B = bkd.Sample(bkdSampler,In.texCoord);
	color.rgb = 1.0-((1.0-B.rgb)*(1.0-L.rgb));
	color.a= L.a;
	color.rgb *= color.a;

	return color;
}
