sampler2D Img;
sampler2D Palette : register(s1);

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	float4 SrcPixel = tex2D(Img,In);
	int Index = 255.0 * SrcPixel.r;
	In.x = (Index % 16) * 0.0625;
	In.y = (Index / 16) * 0.0625;
	SrcPixel = tex2D(Palette, In);
	return SrcPixel;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }