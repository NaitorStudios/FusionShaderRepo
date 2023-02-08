sampler2D img;
float4 textColor;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{
float4 myColor = tex2D( img, texCoord );
return float4( textColor.r, textColor.g, textColor.b, round(myColor.a));
}
technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }