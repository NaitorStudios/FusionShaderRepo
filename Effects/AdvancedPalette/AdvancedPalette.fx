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

sampler2D Tex0 : register(s0);

int swapRed;
int swapGreen;
int swapBlue;
float4 redColor;
float4 greenColor;
float4 blueColor;

PS_OUTPUT ps_main( in PS_INPUT In )
{
	PS_OUTPUT Out;
	const float ALPHA_EPS = 1.0 / 255.0 - 0.0001;
	float4 c = tex2D(Tex0, In.Texture);
	float r_swap = swapRed   * (abs(c.g - c.b) < ALPHA_EPS && c.r > c.g ? 1.0 : 0.0);
	float g_swap = swapGreen * (abs(c.r - c.b) < ALPHA_EPS && c.g > c.b ? 1.0 : 0.0);
	float b_swap = swapBlue  * (abs(c.r - c.g) < ALPHA_EPS && c.b > c.r ? 1.0 : 0.0);
	float3 r_c = redColor.rgb   * c.r + (float3(1.0, 1.0, 1.0) - redColor.rgb)   * c.g;
	float3 g_c = greenColor.rgb * c.g + (float3(1.0, 1.0, 1.0) - greenColor.rgb) * c.b;
	float3 b_c = blueColor.rgb  * c.b + (float3(1.0, 1.0, 1.0) - blueColor.rgb)  * c.r;
	c.rgb = (r_swap + g_swap + b_swap) == 1.0 ? (r_c * r_swap + g_c * g_swap + b_c * b_swap) : c.rgb;
	Out.Color = c;
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