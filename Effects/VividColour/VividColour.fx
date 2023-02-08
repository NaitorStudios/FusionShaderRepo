
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

// Bled coefficient
float3     fBlend;
float fPercent;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    Out.Color = tex2D(Tex0, In.Texture);
    Out.Color.r = fBlend.b*fPercent + Out.Color.r*(1.0f-fPercent);
    Out.Color.g = fBlend.g*fPercent + Out.Color.g*(1.0f-fPercent);
    Out.Color.b = fBlend.r*fPercent + Out.Color.b*(1.0f-fPercent);
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