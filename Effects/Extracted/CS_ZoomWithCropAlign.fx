
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

float xScale;
float yScale;
float xAlign;
float yAlign;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
    In.Texture.x = In.Texture.x + xAlign*(xScale-1.0f);
	In.Texture.y = In.Texture.y + yAlign*(yScale-1.0f);
	Out.Color = tex2D(Tex0, float2(In.Texture.x/xScale,In.Texture.y/yScale));

	// I Have no idea of how the last two comparisons work, took me a while to figure it out.
	if( In.Texture.x>xScale || In.Texture.y>yScale || In.Texture.x<0.0 ||In.Texture.y<0.0f)
	{
		Out.Color.a = 0;
	}
	
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