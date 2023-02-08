
sampler2D Map : register(s1);
sampler2D Tileset : register(s2);

int mapWidth;
int mapHeight;
float2 outPos;
float4 mapColor;
int tileIndex;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	// Get pixel from map
	float4 mapPix = tex2D(Map, In);
	
	float4 checkMap = tex2D(Map, float2(In.x,In.y - (1.0 / mapHeight)));
	tileIndex = any(checkMap != mapColor) ? 1 : 0;
	checkMap = tex2D(Map, float2(In.x+(1.0 / mapWidth),In.y));
	tileIndex = any(checkMap != mapColor) ? tileIndex + 2 : tileIndex;
	checkMap = tex2D(Map, float2(In.x,In.y + (1.0 / mapHeight)));
	tileIndex = any(checkMap != mapColor) ? tileIndex + 4 : tileIndex;
	checkMap = tex2D(Map, float2(In.x-(1.0 / mapWidth),In.y));
	tileIndex = any(checkMap != mapColor) ? tileIndex + 8 : tileIndex;
	
	// Get pixel from tilemap
	outPos.x = (0.25 * (tileIndex % 4.0)) + ((In.x % (1.0 / mapWidth)) * (mapWidth / 4.0));
	outPos.y = (0.25 * int(tileIndex / 4.0 + 0.001)) + ((In.y % (1.0 / mapHeight)) * (mapHeight / 4.0));
	
	// Output
	float4 output = tex2D(Tileset, outPos);
	output.a = any(mapPix != mapColor) ? 0 : output.a;
	return output;
	
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }