// 30/07/2022: improved code

struct PS_INPUT {
	float4 tint : COLOR0;
	float2 texCoord : TEXCOORD0;
	float4 position : SV_POSITION;
};

Texture2D<float4> imgTexture : register(t0);
sampler img : register(s0);

cbuffer PS_VARIABLES : register(b0) {
	// hack: variable names & types don't really matter
	float2 freq;
	float2 amplitude;
	float2 offset;
};

float4 ps_main(in PS_INPUT input) : SV_TARGET {
	float2 sinOffset = float2(sin((input.texCoord.y + offset.x) * freq.x) * amplitude.x,
								sin((input.texCoord.x + offset.y) * freq.y) * amplitude.y);
	input.texCoord += sinOffset;
	return imgTexture.Sample(img, input.texCoord) * input.tint;
}