// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
	float4 Color   : SV_TARGET;
};

cbuffer PS_VARIABLES : register(b0)
{
	int swapRed;
	float4 redColor;
	int swapGreen;
	float4 greenColor;
	int swapBlue;
	float4 blueColor;
}

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
	PS_OUTPUT Out;
	const float ALPHA_EPS = 1.0 / 255.0 - 0.0001;
	float4 c = Tex0.Sample(Tex0Sampler, In.texCoord);
	float r_swap = swapRed   * (abs(c.g - c.b) < ALPHA_EPS && c.r > c.g ? 1.0 : 0.0);
	float g_swap = swapGreen * (abs(c.r - c.b) < ALPHA_EPS && c.g > c.b ? 1.0 : 0.0);
	float b_swap = swapBlue  * (abs(c.r - c.g) < ALPHA_EPS && c.b > c.r ? 1.0 : 0.0);
	float3 r_c = redColor.rgb   * c.r + (float3(1.0, 1.0, 1.0) - redColor.rgb)   * c.g;
	float3 g_c = greenColor.rgb * c.g + (float3(1.0, 1.0, 1.0) - greenColor.rgb) * c.b;
	float3 b_c = blueColor.rgb  * c.b + (float3(1.0, 1.0, 1.0) - blueColor.rgb)  * c.r;
	c.rgb = (r_swap + g_swap + b_swap) == 1.0 ? (r_c * r_swap + g_c * g_swap + b_c * b_swap) : c.rgb;
	Out.Color = Demultiply(c) * In.Tint; 
	return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
	PS_OUTPUT Out;
	const float ALPHA_EPS = 1.0 / 255.0 - 0.0001;
	float4 c = Tex0.Sample(Tex0Sampler, In.texCoord);
	float r_swap = swapRed   * (abs(c.g - c.b) < ALPHA_EPS && c.r > c.g ? 1.0 : 0.0);
	float g_swap = swapGreen * (abs(c.r - c.b) < ALPHA_EPS && c.g > c.b ? 1.0 : 0.0);
	float b_swap = swapBlue  * (abs(c.r - c.g) < ALPHA_EPS && c.b > c.r ? 1.0 : 0.0);
	float3 r_c = redColor.rgb   * c.r + (float3(1.0, 1.0, 1.0) - redColor.rgb)   * c.g;
	float3 g_c = greenColor.rgb * c.g + (float3(1.0, 1.0, 1.0) - greenColor.rgb) * c.b;
	float3 b_c = blueColor.rgb  * c.b + (float3(1.0, 1.0, 1.0) - blueColor.rgb)  * c.r;
	c.rgb = (r_swap + g_swap + b_swap) == 1.0 ? (r_c * r_swap + g_c * g_swap + b_c * b_swap) : c.rgb;
	Out.Color = c * In.Tint;
	return Out;
}