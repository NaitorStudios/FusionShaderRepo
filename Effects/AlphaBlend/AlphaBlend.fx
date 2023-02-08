
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 texCoord    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0 : register(s0); 

float blend;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(Tex0, In);
	color.a = lerp(0.0, color.a, blend);
	return color;
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