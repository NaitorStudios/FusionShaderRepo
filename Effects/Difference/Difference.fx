sampler2D img;
sampler2D bkd : register(s1);

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	float4 O = 1.0;
	O.rgb = abs(tex2D(img,In)-tex2D(bkd,In));
	return O;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }