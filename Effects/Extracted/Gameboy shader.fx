
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

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = tex2D(Tex0, In.Texture);
	float4 f4 = Out.Color * float4(0.299f, 0.587f, 0.114f, 1.0f);
	float f = (round(((f4.r + f4.g + f4.b)/85)*255.0)*85)/255.0;
	Out.Color.r = 0;
	Out.Color.g = f;
	Out.Color.b = 0;

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