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

// Alpha Threshold effect

float threshold;
float smoothness;
float opacity;


float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D( Tex0, In ) ;
	
	float range = ( color.a - (1.0 - threshold) - (smoothness * 0.05) ) / (0.0001 + smoothness * 0.1) ;
	color.a = smoothstep( 0.0, 1.0, range ) ;
	
	color.a = lerp(0.0,color.a,opacity);
	return color ;
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