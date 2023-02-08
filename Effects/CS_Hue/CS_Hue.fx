
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
float fHue;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	PS_OUTPUT Init;
	
	Init.Color = tex2D(Tex0, In.Texture);
    Out.Color.a = Init.Color.a;
	
	if( fHue < 1.0f )
	{
		Out.Color.r = Init.Color.r+(Init.Color.g-Init.Color.r)*fHue;
		Out.Color.g = Init.Color.g+(Init.Color.b-Init.Color.g)*fHue;
		Out.Color.b = Init.Color.b+(Init.Color.r-Init.Color.b)*fHue;
	}
	else if( fHue >= 1.0f && fHue < 2.0 )
	{
		Out.Color.r = Init.Color.g+(Init.Color.b-Init.Color.g)*(fHue-1.0f);
		Out.Color.g = Init.Color.b+(Init.Color.r-Init.Color.b)*(fHue-1.0f);
		Out.Color.b = Init.Color.r+(Init.Color.g-Init.Color.r)*(fHue-1.0f);
	}
	else if( fHue >= 2.0f )
	{
		Out.Color.r = Init.Color.b+(Init.Color.r-Init.Color.b)*(fHue-2.0f);
		Out.Color.g = Init.Color.r+(Init.Color.g-Init.Color.r)*(fHue-2.0f);
		Out.Color.b = Init.Color.g+(Init.Color.b-Init.Color.g)*(fHue-2.0f);
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