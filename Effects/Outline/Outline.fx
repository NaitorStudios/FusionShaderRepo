
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
sampler2D Texture0;
const float fWidth;
const float fHeight;
const float4 fColour;

const float2 samples[8] = {
-1.0,-1.0,
 0.0,-1.0,
 1.0,-1.0,
-1.0, 0.0,
 1.0, 0.0,
-1.0, 1.0,
 0.0, 1.0,
 1.0, 1.0,
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = tex2D(Texture0, In.Texture);
    if ( Out.Color.a < 0.5f )
    {
        for(int i=0; i<8; i++)
        {
            if ( tex2D(Texture0, In.Texture + samples[i]/float2(fWidth,fHeight)).a >= 0.5f )
            {
                Out.Color = fColour;
                // Adding this break makes the shader fail to compile, using too many registers. Odd.
                //break;
            }
        }
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