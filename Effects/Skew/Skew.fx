
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

// User Input variables
float f_X1;
float f_Y1;
float f_X2;
float f_Y2;
float f_X3;
float f_Y3;
float f_X4;
float f_Y4;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
float oldX = In.Texture.x;
float oldY = In.Texture.y;

float scaleX1 = f_X2 - f_X1;
float scaleX2 = f_X4 - f_X3;
float scaleY1 = f_Y3 - f_Y1;
float scaleY2 = f_Y4 - f_Y2;

float newX = (oldX * ((scaleX1 * (1.0f-oldY)) + scaleX2 * oldY)) + ((f_X1 * (1.0f-oldY)) + (f_X3 * oldY));
float newY = (oldY * ((scaleY1 * (1.0f-oldX)) + scaleY2 * oldX)) + ((f_Y1 * (1.0f-oldX)) + (f_Y2 * oldX));

	Out.Color = tex2D(Tex0, float2(newX,newY));
	
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