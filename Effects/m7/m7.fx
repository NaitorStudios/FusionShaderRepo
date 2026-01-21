sampler2D img : register(s0);

float scale1, scale2;


float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{

In.x = 0.5 + ((0.5 - In.x) * In.y);
In.y = pow(In.y, 0.5);

float4 myColor = tex2D( img, In );
return myColor;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_a ps_main(); }  }