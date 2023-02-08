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
float fBlend;
float4 ColorKey;
float Tolerance;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	
float4 color = tex2D( Tex0,In.Texture);
   
if (all(abs(color.rgb - ColorKey.rgb) < Tolerance)) 
{ 
color.rgba = 0;
}
	
    Out.Color = color;
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