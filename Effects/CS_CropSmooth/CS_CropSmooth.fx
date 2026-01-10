
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

float fL;
float fR;
float fT;
float fB;
float fLSmooth;
float fRSmooth;
float fTSmooth;
float fBSmooth;
float fA;
float fPixelWidth;
float fPixelHeight;

float smoothStepEdge(float edge, float smoothness, float coord, float pixelSize)
{
    return smoothstep(edge - smoothness * pixelSize, edge + smoothness * pixelSize, coord);
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = tex2D(Tex0, In.Texture);
    
    float alphaLeft = smoothStepEdge(fL, fLSmooth, In.Texture.x, fPixelWidth);
    float alphaRight = smoothStepEdge(1.0f - fR, fRSmooth, 1.0f - In.Texture.x, fPixelWidth);
    float alphaTop = smoothStepEdge(fT, fTSmooth, In.Texture.y, fPixelHeight);
    float alphaBottom = smoothStepEdge(1.0f - fB, fBSmooth, 1.0f - In.Texture.y, fPixelHeight);

    float alpha = min(min(alphaLeft, alphaRight), min(alphaTop, alphaBottom));

    Out.Color.a *= alpha * fA;
    
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