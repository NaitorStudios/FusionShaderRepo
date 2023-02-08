sampler2D img;
sampler2D bkd : register(s1);

float4 ps_main(in float2 In: TEXCOORD0) : COLOR0	{
	float4 L = tex2D(img,In);
	float4 B = tex2D(bkd,In);
	return (L<0.5)?min(B,(2.0*L)):max(B,(2.0*(L-0.5)));
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }