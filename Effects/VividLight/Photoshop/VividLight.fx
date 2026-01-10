sampler2D img;
sampler2D bkd : register(s1);

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	#define Dodge(B,L)	(L==1.0?1.0:saturate(B/(1.0-L)))
	#define Burn(B,L)		(L==0.0?0.0:saturate((1.0-((1.0-B)/L))))
	float4 L = tex2D(img,In);
	float4 B = tex2D(bkd,In);
	float4 O = L<0.5?Burn(B,(2.0*L)):Dodge(B,(2.0*(L-0.5)));
	O.a = 1.0; // Apparently
	return O;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }