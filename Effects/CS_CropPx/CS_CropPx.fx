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
float fA;

float fPixelWidth, fPixelHeight;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    
    // Normalize the cropping values based on the object size
    float normL = fL * fPixelWidth;
    float normR = fR * fPixelWidth;
    float normT = fT * fPixelHeight;
    float normB = fB * fPixelHeight;
    
    // Check the texture coordinates against the normalized cropping rectangle
    if(In.Texture.x < normL || In.Texture.x > (1.0f - normR) || In.Texture.y < normT || In.Texture.y > (1.0f - normB))
    {
        Out.Color = tex2D(Tex0, In.Texture);
        Out.Color.a = Out.Color.a * fA;
    }
    else
    {
        Out.Color = tex2D(Tex0, In.Texture);
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
