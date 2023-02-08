sampler2D img : register(s0);
sampler2D tex : register(s1);

int texWidth;
int texHeight;
int sprWidth;
int sprHeight;
int sprX;
int sprY;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{
	float4 inColor = tex2D( img,texCoord);
	float4 outColor;
	if (inColor.r == 1 && inColor.g == 0 && inColor.b == 0) {
		float pixX = (((texCoord.x * sprWidth) + sprX) % texWidth) / texWidth;
		float pixY = (((texCoord.y * sprHeight) + sprY) % texHeight) / texHeight;
	outColor = tex2D( tex, float2(pixX, pixY));
	}
	else {
		outColor = inColor;
		}
	return outColor;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); } }