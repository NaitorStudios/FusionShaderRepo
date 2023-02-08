sampler2D img : register(s0);
float minY;
float maxY;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{
float rangeY = maxY - minY;
float4 newColor = tex2D( img, texCoord );
newColor.a = min(1.0-(texCoord.y - minY) / rangeY, newColor.a);
return newColor;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }