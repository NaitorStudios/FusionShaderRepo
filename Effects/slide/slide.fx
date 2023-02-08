// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0;

float slideX;
float slideY;
float fPixelWidth;
float fPixelHeight;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, float2(In.Texture.x-(slideX*fPixelWidth),In.Texture.y-(slideY*fPixelHeight)));
	
    return Out;
}

technique tech_main
{
  pass P0{PixelShader  = compile ps_2_0 ps_main();}
}