//For greyscale

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

float threshold;
float lowerclamp;
float upperclamp;
float opacity;


float4 ps_main( in PS_INPUT In ) : COLOR0
{
	// Retrieve source pixel
	float4 front = tex2D(Tex0, In.texCoord);
	
	// Apply threshold
	front.a = (front.a < threshold ? lowerclamp : upperclamp);
	
	// Apply clamped alpha
	front.a = lerp(0.0,front.a,opacity);

	return front;
}


// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_1_1 ps_main();
    }  
}