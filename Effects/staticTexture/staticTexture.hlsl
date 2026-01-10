struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;  //SV_POSITION is used in vertex shader
};

struct PS_OUTPUT
{
    float4 Color : SV_Target;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);
Texture2D<float4> tex : register(t1);
sampler texSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	int texWidth;
	int texHeight;
	int sprWidth;
	int sprHeight;
	int sprX;
	int sprY;
}

float4 ps_main(PS_INPUT In) : SV_Target {
	float4 inColor = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float4 outColor;
	if (inColor.r == 1 && inColor.g == 0 && inColor.b == 0) {
		float pixX = (((In.texCoord.x * sprWidth) + sprX) % texWidth) / texWidth;
		float pixY = (((In.texCoord.y * sprHeight) + sprY) % texHeight) / texHeight;
	outColor = tex.Sample(texSampler, float2(pixX, pixY));
	}
	else {
		outColor = inColor;
		}
	return outColor;
}
