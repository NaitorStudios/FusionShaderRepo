#define BlendColorBurnf(base, blend) 	((blend == 0.0) ? blend : max((1.0 - ((1.0 - base) / blend)), 0.0))

sampler2D img;
float4 color = {1,1,1,1};

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	float4 B = tex2D(img,In);
	float4 O = BlendColorBurnf(B,color);
	O.a = B.a; 

	return O;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }