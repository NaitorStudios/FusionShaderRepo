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
	#define Dodge(B,L)	(L==1.0?1.0:saturate(B/(1.0-L)))
	#define Burn(B,L)		(L==0.0?0.0:saturate((1.0-((1.0-B)/L))))
	float4 L = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float4 B = bkd.Sample(bkdSampler,In.texCoord);
	float4 O = L<0.5?Burn(B,(2.0*L)):Dodge(B,(2.0*(L-0.5)));
	O.r = O.r>0.5?1.0:0.0;
	O.g = O.g>0.5?1.0:0.0;
	O.b = O.b>0.5?1.0:0.0;
	O.a = 1.0;
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
	#define Dodge(B,L)	(L==1.0?1.0:saturate(B/(1.0-L)))
	#define Burn(B,L)		(L==0.0?0.0:saturate((1.0-((1.0-B)/L))))
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord) * In.Tint);
	float4 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
	float4 O = L<0.5?Burn(B,(2.0*L)):Dodge(B,(2.0*(L-0.5)));
	O.r = O.r>0.5?1.0:0.0;
	O.g = O.g>0.5?1.0:0.0;
	O.b = O.b>0.5?1.0:0.0;
	O.a = 1.0;
	return O;
}
