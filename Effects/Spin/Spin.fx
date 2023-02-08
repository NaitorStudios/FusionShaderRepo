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

float fAngle;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	float2 srcPos;
	srcPos = In.Texture.xy;
	srcPos.x = ((srcPos.x-0.5)/cos(fAngle*0.0174532925))+0.5; 
	Out.Color = tex2D(Tex0,srcPos.xy);
	if (srcPos.x < 0 || srcPos.x > 1 ) {
		Out.Color.a=0;
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