
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

// Shader variables
float fAngleX;
float fAngleY;
float fOffsetX;
float fOffsetY;

float fPixelWidth;
float fPixelHeight;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    Out.Color = tex2D(Tex0, In.Texture);
    float2 OffsetPos = float2(In.Texture.x / fPixelWidth - fOffsetX, In.Texture.y  / fPixelHeight - fOffsetY);
    float DotResult = OffsetPos.x * fAngleX + OffsetPos.y * fAngleY;
    if (DotResult < 0) {
        Out.Color.a = 0.0f;
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