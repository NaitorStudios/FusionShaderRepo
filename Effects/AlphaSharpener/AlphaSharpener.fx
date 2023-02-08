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

// Alpha Threshold effect

float s;


float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D( Tex0, In );
	if (color.a < s)
		color.a = 0.0;
	else
		color.a = 1.0;
	
	return color ;
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