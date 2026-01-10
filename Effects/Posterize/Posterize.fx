
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
float fGam;
float numColors;

float4 Posterize(in float4 inputColor)
{
	float3 c =inputColor.xyz;
	c = pow(c, float3(fGam, fGam, fGam));
	c = floor(c * numColors);
	c = c / numColors;
	c = pow(c, float3(1.0/fGam,1.0/fGam,1.0/fGam));
	
	return float4(c, inputColor.a);
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

	Out.Color = tex2D(Tex0, In.Texture);
	Out.Color = Posterize(Out.Color);

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