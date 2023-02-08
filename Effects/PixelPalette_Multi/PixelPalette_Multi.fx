sampler2D img : register(s0);
sampler2D Palettes = sampler_state {
	MinFilter = Point;
	MagFilter = Point;
};

int nPal, lerpA, lerpB;
float lerpVal;

float4 PixelPalette(float2 texCoord : TEXCOORD ) : COLOR
{
	float4 output = tex2D(img, texCoord);
	float index = tex2D(img, texCoord).r;
	
	float odd = float(nPal) % 2;
	float4 colorA = tex2D(Palettes, float2(index, (lerpA + odd) / float(nPal)));
	float4 colorB = tex2D(Palettes, float2(index, (lerpB + odd) / float(nPal)));
	output = float4(lerp(colorA.rgb, colorB.rgb, lerpVal), output.a);

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