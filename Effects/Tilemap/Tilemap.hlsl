struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> Map : register(t1);
sampler MapSampler : register(s1);
Texture2D<float4> Tileset : register(t2);
sampler TilesetSampler : register(s2);

cbuffer PS_VARIABLES : register(b0)
{
int mapWidth;
int mapHeight;
int tilesetWidth;
int tilesetHeight;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float2 offset;
	float2 Out;

	// Get pixel from map
	float4 mapPix = Map.Sample(MapSampler, In.texCoord)  * In.Tint;

	// Get tile index from red component
	float tileIndex = 255.0 * mapPix.r;

	// Calculate offset of pixel within tile
	offset.x = (In.texCoord.x % (1.0 / mapWidth)) * (mapWidth / tilesetWidth);
	offset.y = (In.texCoord.y % (1.0 / mapHeight)) * (mapHeight / tilesetHeight);

	// Get pixel from tilemap
	Out.x = ((1.0 / tilesetWidth) * (tileIndex % tilesetWidth)) + offset.x;
	Out.y = ((1.0 / tilesetHeight) * int(tileIndex / tilesetWidth + 0.001)) + offset.y;

	// Output
	return Tileset.Sample(TilesetSampler, Out)  * In.Tint;
}
