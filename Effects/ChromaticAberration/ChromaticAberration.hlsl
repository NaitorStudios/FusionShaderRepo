// 19/08/2023: Rewrote code and added intensity

struct PS_INPUT {
	float4 tint : COLOR0;
	float2 texCoord : TEXCOORD0;
	float4 position : SV_POSITION;
};

Texture2D<float4> imgTexture : register(t0);
sampler img : register(s0);

cbuffer PS_VARIABLES : register(b0) {
    float amountX;
    float amountY;
    float intensity;
};

float4 ps_main(in PS_INPUT input) : SV_TARGET {
    float2 amount = float2(amountX, amountY);

    float4 color = imgTexture.Sample(img, input.texCoord);
    color.r = lerp(color.r, imgTexture.Sample(img, input.texCoord + amount).r, intensity);
    color.b = lerp(color.b, imgTexture.Sample(img, input.texCoord - amount).b, intensity);

    return color * input.tint;
}