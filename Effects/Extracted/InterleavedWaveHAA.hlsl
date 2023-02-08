struct PS_INPUT {
	float4 tint : COLOR0;
	float2 texCoord : TEXCOORD0;
	float4 position : SV_POSITION;
};

Texture2D<float4> imgTexture : register(t0);
sampler img : register(s0);

cbuffer PS_VARIABLES : register(b0) {
	float freq;
	float amplitude;
	float offset;
	float period;
};

cbuffer PS_PIXELSIZE : register(b1) {
	float fPixelWidth;
	float fPixelHeight;
};

static const float PI = 3.14159265f;

float4 ps_main(in PS_INPUT input) : SV_TARGET {
	float offsetX = sin((input.texCoord.y + offset) * freq) * amplitude;
	
	float intlv = sin(input.texCoord.y * (1.0f - period) / fPixelHeight * PI);

	if (intlv >= 0.0) {
		input.texCoord.x += offsetX;
	}
	else {
		input.texCoord.x -= offsetX;
	}

	return imgTexture.Sample(img, input.texCoord) * input.tint;
}