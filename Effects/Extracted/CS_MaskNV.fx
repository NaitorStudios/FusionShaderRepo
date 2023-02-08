
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
float fCoeff;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = tex2D(Tex0, In.Texture);

	float4 f4 = Out.Color * float4(0.0f, 2.0f, 0.0f, 1.0f);
	Out.Color.rgb = f4;

	float f = (Out.Color.r+Out.Color.g+Out.Color.b);
	Out.Color.rgb = f*fCoeff+Out.Color.rgb;

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