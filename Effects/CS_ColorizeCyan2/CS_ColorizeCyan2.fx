
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

//Tint color
float4 fTint;
float fCoeff;
float fMinLuminance;
float fMaxLuminance;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, In.Texture);
	float luminance = 0.299 * Out.Color.r + 0.587 * Out.Color.g + 0.114 * Out.Color.b;
	
	if(luminance > fMinLuminance && luminance < fMaxLuminance && Out.Color.g>Out.Color.b-fCoeff &&
		Out.Color.g<Out.Color.b+fCoeff &&
		Out.Color.r<fCoeff)
	{
		Out.Color.rgb = Out.Color.g*fTint.rgb;
	}
	
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