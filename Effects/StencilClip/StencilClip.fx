
// Pixel shader input structure
struct PS_INPUT {
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT {
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0;
sampler2D bgTex : register(s1);

// PS_VARIABLES
float4 stencilColor;
float tolerance;

PS_OUTPUT ps_main( in PS_INPUT In ) {
    // Output pixel
    PS_OUTPUT Out;
    float4 bg = tex2D(bgTex, In.Texture);
    float4 fg = tex2D(Tex0, In.Texture);

    float dist = (bg.r - stencilColor.r) * (bg.r - stencilColor.r) +
                 (bg.g - stencilColor.g) * (bg.g - stencilColor.g) +
                 (bg.b - stencilColor.b) * (bg.b - stencilColor.b);

    Out.Color.rgba = fg.rgba;
    if (dist > tolerance * tolerance)
      Out.Color.rgba = 0.0f;

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
