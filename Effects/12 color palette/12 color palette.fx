
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

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = tex2D(Tex0, In.Texture);
	float4 f4 = Out.Color;
	float red = (round(((Out.Color.r)/85)*255.0)*85)/255.0;
	float green = (round(((Out.Color.g)/127.5)*255.0)*127.5)/255.0;
	float blue = (round(((Out.Color.b)/127.5)*255.0)*127.5)/255.0;
	Out.Color.r = red;
	Out.Color.g = green;
	Out.Color.b = blue;

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