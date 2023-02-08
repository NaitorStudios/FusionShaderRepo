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

float HardMix(float base, float blend)
{
	return (base + blend >= 1.0) ? 1.0 : 0.0;
}

float4 ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord));
	float4 B = bkd.Sample(bkdSampler,In.texCoord);
	float4 O = float4(  HardMix(B.r, L.r), 
						HardMix(B.g, L.g), 
						HardMix(B.b, L.b),
									 L.a);

	return O * In.Tint;
}


float4 ps_main_pm(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord));
	float4 B = bkd.Sample(bkdSampler,In.texCoord);
	float4 O = float4(  HardMix(B.r, L.r), 
						HardMix(B.g, L.g), 
						HardMix(B.b, L.b),
									 L.a);
	O.rgb *= O.a;

	return O * In.Tint;
}
