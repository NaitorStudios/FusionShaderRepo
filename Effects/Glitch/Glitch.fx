// Global variables
int fPow;
int fBleed;

sampler2D Tex0 : register(s0) = sampler_state {
	MinFilter = None; 
	MagFilter = None; 
	MipFilter = None; 
};

sampler2D dist_map : register(s1) = sampler_state {
	MinFilter = None; 
	MagFilter = None; 
	MipFilter = None;
};

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

PS_OUTPUT ps_main(in PS_INPUT In)
{
	float distortion = tex2D(dist_map, float2(In.Texture.x, In.Texture.y)).r *2.0 - 1.0;
	distortion = distortion / fPow;
	float distortion2 = tex2D(Tex0, float2(In.Texture.x, In.Texture.y)).g / fBleed;
	PS_OUTPUT Out;
	PS_OUTPUT distorted;
	PS_OUTPUT PXT;
	PS_OUTPUT PXTL;
	PS_OUTPUT PXL;
	PS_OUTPUT PXBL;
	PS_OUTPUT PXB;
	PS_OUTPUT PXBR;
	PS_OUTPUT PXR;
	PS_OUTPUT PXTR;
	distorted.Color = tex2D(Tex0, float2(In.Texture.x + distortion, In.Texture.y)) * 8;
	PXT.Color = tex2D(Tex0, float2(In.Texture.x, In.Texture.y - distortion2));
	PXTL.Color = tex2D(Tex0, float2(In.Texture.x - distortion2, In.Texture.y - distortion2));
	PXL.Color = tex2D(Tex0, float2(In.Texture.x - distortion2, In.Texture.y));
	PXBL.Color = tex2D(Tex0, float2(In.Texture.x - distortion2, In.Texture.y + distortion2));
	PXB.Color = tex2D(Tex0, float2(In.Texture.x, In.Texture.y + distortion2));
	PXBR.Color = tex2D(Tex0, float2(In.Texture.x + distortion2, In.Texture.y + distortion2));
	PXR.Color = tex2D(Tex0, float2(In.Texture.x + distortion2, In.Texture.y));
	PXTR.Color = tex2D(Tex0, float2(In.Texture.x + distortion2, In.Texture.y - distortion2));
	Out.Color = (distorted.Color + PXT.Color + PXTL.Color + PXL.Color + PXBL.Color + PXB.Color + PXBR.Color + PXR.Color + PXTR.Color) / 9;

	return Out;
}

// Effect technique
technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader = NULL;
		PixelShader = compile ps_2_0 ps_main();
	}
}