
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
sampler2D bkd : register(s1)= sampler_state{
   AddressU = Wrap;
   AddressV =   Wrap;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = tex2D(Tex0, In.Texture);
    float4 bg = tex2D(bkd , In.Texture);

    float4 f = float4((bg.r + 1.0f) / 2.0f,
                      (bg.g + 1.0f) / 2.0f,
                      (bg.b + 1.0f) / 2.0f,
                      Out.Color.a);
    Out.Color.rgba = f;

    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }
}
