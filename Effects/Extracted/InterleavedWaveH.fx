sampler2D img = sampler_state {
  MinFilter = Point;
  MagFilter = Point;
};

float freq;
float amplitude;
float offset;
float period;

float fPixelHeight;

static const float PI = 3.14159265f;

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR {
	float offsetX = sin((texCoord.y + offset) * freq) * amplitude;
	
	float intlv = sin(texCoord.y * (1.0f - period) / fPixelHeight * PI);

	if (intlv >= 0.0) {
		texCoord.x += offsetX;
	}
	else {
		texCoord.x -= offsetX;
	}

	return tex2D(img, texCoord);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); }}