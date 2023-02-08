sampler2D Tex0;
sampler2D PaletteA;
sampler2D PaletteB;

float lerpVal;

float4 PixelPalette(float2 texCoord : TEXCOORD ) : COLOR
{
	float4 output;

	float texChannelRed = tex2D(Tex0, texCoord).r;
	float4 colorA = tex2D(PaletteA, float2(texChannelRed, 0));
	float4 colorB = tex2D(PaletteB, float2(texChannelRed, 0));

	output = lerp(colorA, colorB, lerpVal);
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