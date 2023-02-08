sampler2D Tex0;
sampler2D PaletteA;
sampler2D PaletteB;
sampler2D PaletteC;
sampler2D PaletteD;

int palette;
float4 curPal;

float4 PixelPalette(float2 texCoord : TEXCOORD ) : COLOR
{
	float4 output;

	float texChannelRed = tex2D(Tex0, texCoord).r;
	float4 colorA = tex2D(PaletteA, float2(texChannelRed, 0));
	float4 colorB = tex2D(PaletteB, float2(texChannelRed, 0));
	float4 colorC = tex2D(PaletteC, float2(texChannelRed, 0));
	float4 colorD = tex2D(PaletteD, float2(texChannelRed, 0));			

	if (palette == 0) {curPal = colorA;}
	else if (palette == 1) {curPal = colorB;}
	else if (palette == 2) {curPal = colorC;}
	else if (palette == 3) {curPal = colorD;};

	output = curPal;
	output.a = tex2D(Tex0, texCoord).a;

	return output;
}

technique tech_main
{
	pass p0
	{
		VertexShader = null;
		PixelShader = compile ps_2_0 PixelPalette();
	}
}