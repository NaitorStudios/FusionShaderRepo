
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
sampler2D fImage : register(s1);
float fValue;

// Blend coefficient

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float4 p = tex2D(fImage,In.Texture);
    Out.Color = tex2D(Tex0, In.Texture);
    float result = (p.r + p.g + p.b)/3.0;
    if( result < 1.0 - fValue){
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
        PixelShader  = compile ps_1_4 ps_main();
    }  
}