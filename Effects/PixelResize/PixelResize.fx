
sampler2D img : register(s0);

int fWidth;
int fHeight;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float2 i = float2((floor(texCoord.x * fWidth * 0.5) + 0.5) * (1.0 / fWidth), (floor(texCoord.y * fHeight * 0.5) + 0.5) * (1.0 / fHeight));
return float4(tex2D(img, i));
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_a ps_main(); }  }