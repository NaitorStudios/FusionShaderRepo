
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
float fScale;
float fOffsetX;
float fOffsetY;
float fCx;
float fCy;
int fMaxIter;


PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
	PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, In.Texture);
float2 z;
z.x = (In.Texture.x-0.5)* fScale-fOffsetX;
z.y = (In.Texture.y-0.5)* fScale-fOffsetY;
int i;
bool stop = false;

for(i=0; i<fMaxIter && !stop; i++) 
{
        float x = (z.x * z.x - z.y * z.y) + fCy;
        float y = (z.y * z.x + z.x * z.y) + fCx;
        if((y * y + x * y) > 4.0) stop = true;
        z.x = x;
        z.y = y;
}

Out.Color.b= (float)(i/(float)(fMaxIter)); 

    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_3_0 ps_main();
    }  
}