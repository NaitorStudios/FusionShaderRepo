
sampler2D Map : register(s1);
sampler2D Tileset : register(s2);

int mapWidth;
int mapHeight;
int tilesetWidth;
int tilesetHeight;
float2 offset;
float2 Out;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	// Get pixel from map
	float4 mapPix = tex2D(Map, In);

	// Get tile index from red component
	float tileIndex = 255.0 * mapPix.r;

	// Calculate offset of pixel within tile
	offset.x = (In.x % (1.0 / mapWidth)) * (mapWidth / tilesetWidth);
	offset.y = (In.y % (1.0 / mapHeight)) * (mapHeight / tilesetHeight);

	// Get pixel from tilemap
	Out.x = ((1.0 / tilesetWidth) * (tileIndex % tilesetWidth)) + offset.x;
	Out.y = ((1.0 / tilesetHeight) * int(tileIndex / tilesetWidth + 0.001)) + offset.y;

	// Output
	return tex2D(Tileset, Out);
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }