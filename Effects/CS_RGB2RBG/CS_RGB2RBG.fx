
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
    PS_OUTPUT Def;
    PS_OUTPUT Out;

	Def.Color = tex2D(Tex0, In.Texture);
    Out.Color = tex2D(Tex0, In.Texture);
	Out.Color.r = Def.Color.r;
	Out.Color.b = Def.Color.g;
	Out.Color.g = Def.Color.b;

    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_1_0 ps_main();
    }  
}