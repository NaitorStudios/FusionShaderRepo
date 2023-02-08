
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
float fAmplitude;
float fPeriods;
float fFreq;
float fLight;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	float fY = In.Texture.y;
	float fShadow;
	
	In.Texture.y = In.Texture.y + (sin((In.Texture.x+fFreq)*fPeriods)*fAmplitude);
	
	fShadow = (In.Texture.y-fY)*100.0f*fLight*fAmplitude;
	
	Out.Color = tex2D(Tex0, In.Texture.xy);
	Out.Color.rgb = Out.Color.rgb+fShadow;

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