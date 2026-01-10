
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
sampler1D image1 : register(s1); 

float fScale;
float fOffsetX;
float fOffsetY;
int fMaxIter;


PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
	PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, In.Texture);

float2 z;
float2 c;

    c.x = 1.3333 * (In.Texture.x - 0.5) * fScale - fOffsetX;
    c.y = (In.Texture.y - 0.5) * fScale - fOffsetY;

bool stop = false;
int i;
z = c;
for(i=0; i<fMaxIter && !stop; i++) 
{
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (z.y * z.x + z.x * z.y) + c.y;

        if((x * x + y * y) > 4.0) stop=true;
        z.x = x;
        z.y = y;
    }


Out.Color= tex1D( image1,(float)(i == fMaxIter ? 0 : i) / 100);

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