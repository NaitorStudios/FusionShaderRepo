// Pixel Shader Input and Output Structures
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Variables
sampler2D Tex0;
float color_r;
float color_g;
float color_b;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT PixelOutput; // Create the Output Pixel
    PixelOutput.Color = tex2D(Tex0, In.Texture);
    PixelOutput.Color.r = color_r;
    PixelOutput.Color.g = color_g;
    PixelOutput.Color.b = color_b;
    return PixelOutput;
}

technique tech_main // The effect technique
{
    pass P0
    {
        // Shaders
        VertexShader = NULL;
        PixelShader  = compile ps_1_1 ps_main();
    }
}