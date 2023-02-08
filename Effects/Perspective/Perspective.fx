
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

float fA;
float fB;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    float ScreenX = (fA+(fB-fA)*In.Texture.y)/2;
    ScreenX = (ScreenX+In.Texture.x-0.5)/ScreenX/2;
    
    if(ScreenX >= 0 && ScreenX <= 1)
    	Out.Color = tex2D(Texture0,float2(ScreenX,In.Texture.y));
    else Out.Color = float4(0,0,0,0);
    
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