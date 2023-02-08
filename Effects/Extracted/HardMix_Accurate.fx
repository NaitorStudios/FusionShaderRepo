sampler2D img;
sampler2D bkd : register(s1);


float HardMix(float base, float blend)
{
	return (base + blend >= 1.0) ? 1.0 : 0.0;
}

float4 ps_main(float4 color : COLOR0,in float2 In : TEXCOORD0) : COLOR0	{
  	float4 L = tex2D(img,In);
  	float4 B = tex2D(bkd,In);
	return float4(  HardMix(B.r, L.r), 
					HardMix(B.g, L.g), 
					HardMix(B.b, L.b),
								 L.a);
}




technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
