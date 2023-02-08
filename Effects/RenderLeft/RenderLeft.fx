
// Pixel shader input structure
sampler2D mainTex;

struct PS_INPUT
{
	float4 pos : POSITION;
	float2 uv : TEXCOORD0;
};

struct PS_OUTPUT
{
	float4 color : COLOR0;
};

float fillAmount = 0.5F;

PS_OUTPUT ps_main(in PS_INPUT i)
{
	PS_OUTPUT o;

	if (i.uv.x < fillAmount)
	{
		o.color = tex2D(mainTex, i.uv);
	}
	else
	{
		discard;
	}

	return o;
}

technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader = NULL;
		PixelShader = compile ps_1_4 ps_main();
	}
}