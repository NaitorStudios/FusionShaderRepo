sampler2D img;
sampler2D bkd : register(s1);

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	return saturate(tex2D(img,In)+tex2D(bkd,In));
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }