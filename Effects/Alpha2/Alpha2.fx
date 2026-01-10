sampler2D Img;
sampler2D Alpha : register(s1);

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	float4 SrcPixel = tex2D(Img,In);
	SrcPixel.a = tex2D(Alpha, In).r * SrcPixel.a;
	return SrcPixel;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }