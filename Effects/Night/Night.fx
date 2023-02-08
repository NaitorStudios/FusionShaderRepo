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
    Out.Color = tex2D(Tex0,In.Texture.xy);
    Out.Color.rg = Out.Color.rg * 0.5;
	float f = (Out.Color.r+Out.Color.g+Out.Color.b)/3;
	if (f>0.5) { f = f+0.25;}
	Out.Color.rgb = f*(1.0f-0.5)+Out.Color.rgb*0.5;
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