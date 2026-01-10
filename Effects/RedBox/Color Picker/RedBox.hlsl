// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

cbuffer PS_VARIABLES : register(b0)
{
	int fGreen;
	int fBlue;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
		float R = In.texCoord.x;
		float G = fGreen / 255.0;
		float B = fBlue / 255.0;
		Out.Color = float4( R, G, B, 1 );
    return Out;
}


