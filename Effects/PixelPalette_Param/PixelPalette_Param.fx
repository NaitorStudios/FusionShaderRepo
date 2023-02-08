sampler2D img : register(s0);

float4 c[20];

float4 PixelPalette(float2 texCoord : TEXCOORD ) : COLOR
{
	float4 output = tex2D(img, texCoord);
	int index = tex2D(img, texCoord).r*255;
	output = float4(c[index].rgb,output.a);

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