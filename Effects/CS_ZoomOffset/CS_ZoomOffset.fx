
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

float fWidth;
float fHeight;
float fZoomX;
float fZoomY;
float fX;
float fY;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
    In.Texture.x = In.Texture.x + fZoomX*(fWidth-1.0f) + fX;
	In.Texture.y = In.Texture.y + fZoomY*(fHeight-1.0f) + fY;
	Out.Color = tex2D(Tex0, float2(In.Texture.x/fWidth,In.Texture.y/fHeight));
	
    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}