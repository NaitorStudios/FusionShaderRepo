
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
sampler2D Tex0;
float4 alphaColor;
bool keepAlpha;

float4 ps_main( in PS_INPUT In ) : COLOR0
{
	float4 color = tex2D(Tex0, In.texCoord);
	if (all(color.rgb == alphaColor.xyz)) { 
		color.a = 0.0;
	} else if (!keepAlpha) {
		color.a = 1.0;
	}
	
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