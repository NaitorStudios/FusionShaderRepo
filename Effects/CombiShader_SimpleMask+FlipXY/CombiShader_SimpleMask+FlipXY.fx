
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

float4 fC;
float fFade;
bool flipX, flipY;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
    // Output pixel
    float4 Out;
	
	if(flipX){ In.x = 1.0 - In.x; }
    if(flipY){ In.y = 1.0 - In.y; }
	
    Out = tex2D(Tex0,In);
    Out.rgb = Out.rgb+(fC-Out.rgb)*fFade;
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