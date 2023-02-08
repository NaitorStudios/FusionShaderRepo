
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

float fRx;
float fRy;
float fGx;
float fGy;
float fBx;
float fBy;
float fAx;
float fAy;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    PS_OUTPUT R;
    PS_OUTPUT G;
    PS_OUTPUT B;
    PS_OUTPUT A;
    R.Color = tex2D(Tex0,float2((In.Texture.x+fRx)%1,(In.Texture.y+fRy)%1));
    G.Color = tex2D(Tex0,float2((In.Texture.x+fGx)%1,(In.Texture.y+fGy)%1));
    B.Color = tex2D(Tex0,float2((In.Texture.x+fBx)%1,(In.Texture.y+fBy)%1));
    A.Color = tex2D(Tex0,float2((In.Texture.x+fAx)%1,(In.Texture.y+fAy)%1));
    Out.Color.r = R.Color.r;
    Out.Color.g = G.Color.g;
    Out.Color.b = B.Color.b;
    Out.Color.a = A.Color.a;
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