
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};


Texture2D<float4> bkd : register(t0);
sampler bkdSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float Step;
	float Intensity;
	float X, Y;
}

float4 ps_main(PS_INPUT In) : SV_TARGET
{
	float w = X - In.texCoord.x;
	float h = Y - In.texCoord.y;
	float distanceFromCenter = sqrt(w * w + h * h);
	
	float sinArg = distanceFromCenter * 10.0 - Step * 4.0;
	float slope = cos(sinArg) * Intensity;
	float4 color = bkd.Sample(bkdSampler, In.texCoord.xy + normalize(float2(w, h)) * slope * 0.05) * In.Tint;
	
	return color;
}

