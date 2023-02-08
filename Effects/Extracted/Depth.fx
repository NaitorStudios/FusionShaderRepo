
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
float fOffset;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = tex2D(Tex0, In.Texture);
	fCoeff *= 1.001;
	if(fCoeff > 0) {
	Out.Color.r = int((Out.Color.r+fOffset)/fCoeff*255)/255*fCoeff;
	Out.Color.g = int((Out.Color.g+fOffset)/fCoeff*255)/255*fCoeff;
	Out.Color.b = int((Out.Color.b+fOffset)/fCoeff*255)/255*fCoeff;
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