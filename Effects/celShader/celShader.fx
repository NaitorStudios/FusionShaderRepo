 
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

int h;

float bright;
float dark;
float red;
float green;
float blue;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = tex2D(Tex0, In.Texture);

	red = float(int((Out.Color.r *255) / h) * h) / 255;
	green = float(int((Out.Color.g *255) / h) * h) / 255;
	blue = float(int((Out.Color.b *255) / h) * h) / 255;

	if (red > bright)
	{
		red = 1;
	}
	else if (red < dark)
	{
		red = 0;
	}
	
	if (green > bright)
	{
		green = 1;
	}
	else if (green < dark)
	{
		green = 0;
	}
	
	if (blue > bright)
	{
		blue = 1;
	}
	else if (blue < dark)
	{
		blue = 0;
	}
	
	Out.Color.r = red;
	Out.Color.g = green;
	Out.Color.b = blue;
	
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