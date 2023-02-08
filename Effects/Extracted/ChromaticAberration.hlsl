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
};

float4 ps_main(in PS_INPUT input) : SV_TARGET {
  float red = imgTexture.Sample(img, float2(input.texCoord.x + amountX, input.texCoord.y + amountY)).r;
  float green = imgTexture.Sample(img, input.texCoord).g;
  float blue = imgTexture.Sample(img, float2(input.texCoord.x - amountX, input.texCoord.y - amountY)).b;
  float alpha = imgTexture.Sample(img, input.texCoord).a;
  
  return float4(red, green, blue, alpha) * input.tint;
}