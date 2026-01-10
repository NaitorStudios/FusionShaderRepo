// 30/07/2022: fixed incorrect period

sampler2D img = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
};

float freq;
float amplitude;
float offset;
float period;

float fPixelWidth;

static const float PI = 3.14159265f;

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR {
	float offsetY = sin((texCoord.x + offset) * freq) * amplitude;
	
	float intlv = sin(texCoord.x * (1.0f - period) / fPixelWidth * PI);

	if (intlv >= 0.0) {
		texCoord.y += offsetY;
	}
	else {
		texCoord.y -= offsetY;
	}

	return tex2D(img, texCoord);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); }}