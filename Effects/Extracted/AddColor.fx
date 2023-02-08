
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
float4 color;
float semitransparency;
int inverted;

PS_OUTPUT ps_main( in PS_INPUT In ) {
    // Output pixel
    PS_OUTPUT Out;

    float4 srcColor = tex2D(Tex0, In.Texture);
    float4 bg = tex2D(bgTex, In.Texture);

    Out.Color.rgba = float4((srcColor.r + color.r) * (1.0 - semitransparency) + bg.r * semitransparency,
                            (srcColor.g + color.g) * (1.0 - semitransparency) + bg.r * semitransparency,
                            (srcColor.b + color.b) * (1.0 - semitransparency) + bg.r * semitransparency,
                            srcColor.a);

    if (inverted != 0) {
      Out.Color.rgb = 1.0 - Out.Color.rgb;
    }

    return Out;
}

// Effect technique
technique tech_main {
    pass P0 {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }
}
