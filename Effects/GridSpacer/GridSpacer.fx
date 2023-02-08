
sampler2D img;
sampler2D bkd : register(s1);

float2 square;
float2 offset;
float2 sourceCoord;
float4 outColor;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

square.x = int((texCoord.x * 170) / 17.0);
square.y = int((texCoord.y * 153) / 17.0);
offset.x = ((texCoord.x * 170) % 17.0);
offset.y = ((texCoord.y * 153) % 17.0);
sourceCoord.x = (square.x * (1.0 / 10.0)) + ((1.0/160.0) * offset.x) - (10*(1.0/160))+ (square.x*(1.0/170));
sourceCoord.y = (square.y * (1.0 / 9.0)) + ((1.0/144.0) * offset.y) - (10*(1.0/144))+ (square.y*(1.0/153));

outColor = tex2D( bkd, sourceCoord );

if (int(offset.x) == 16 || int(offset.y) == 16) {
outColor.a = 0;
}

return outColor;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
