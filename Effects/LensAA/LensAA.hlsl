
// New pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Global variables
Texture2D<float4> lens : register(t0);
sampler lensSampler : register(s0) {
    MinFilter = Linear;
    MagFilter = Linear;
};

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1) {
    MinFilter = Linear;
    MagFilter = Linear;
};

cbuffer PS_VARIABLES : register(b0)
{
	float fCoeff;
	float fBase;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float height = fBase+lens.Sample(lensSampler,In.texCoord).r*fCoeff * In.Tint.r;
	In.texCoord.x += (height-1.0f)/2.0;
	In.texCoord.y += (height-1.0f)/2.0;
	return bg.Sample(bgSampler,float2(In.texCoord.x/height,In.texCoord.y/height));
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 tc = lens.Sample(lensSampler,In.texCoord) * In.Tint;
	if ( tc.a != 0 )
		tc.r /= tc.a;
	float height = fBase+tc.r*fCoeff;
	In.texCoord.x += (height-1.0f)/2.0;
	In.texCoord.y += (height-1.0f)/2.0;
	return bg.Sample(bgSampler,float2(In.texCoord.x/height,In.texCoord.y/height));
}
