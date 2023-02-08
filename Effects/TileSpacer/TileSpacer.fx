sampler2D img;
sampler2D bkd : register(s1);

int imgWidth;
int imgHeight;
int tileWidth;
int tileHeight;
float2 tile;
float2 offset;
float2 srcCoord;
float4 outColor;
float4 bgColor;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

tile.x = int( texCoord.x * imgWidth / ( tileWidth + 1 ));
tile.y = int( texCoord.y * imgHeight / ( tileHeight + 1 ));

offset.x = ( texCoord.x * imgWidth ) % ( tileWidth + 1 );
offset.y = ( texCoord.y * imgHeight ) % ( tileHeight + 1 );

srcCoord.x = ( 1.0 / imgWidth ) * (( tile.x * tileWidth ) + offset.x );
srcCoord.y = ( 1.0 / imgHeight ) * (( tile.y * tileHeight ) + offset.y );

if (int(offset.x) == tileWidth || int(offset.y) == tileHeight) {
outColor = bgColor;
outColor.a = 1;
}
else
{
outColor = tex2D( bkd, srcCoord );
}

return outColor;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }