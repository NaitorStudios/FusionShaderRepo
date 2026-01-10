// 30/07/2022: improved code

sampler2D img = sampler_state {
  MinFilter = Point;
  MagFilter = Point;
};

float freqX, freqY;
float amplitudeX, amplitudeY;
float offsetX, offsetY;

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR {
	float2 sinOffset = float2(sin((texCoord.x + offsetX) * freqX) * amplitudeX,
								sin((texCoord.y + offsetY) * freqY) * amplitudeY);
	texCoord += sinOffset;
	return tex2D(img, texCoord);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); }}