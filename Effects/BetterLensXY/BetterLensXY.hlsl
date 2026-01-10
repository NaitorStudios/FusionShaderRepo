
// New pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Global variables
Texture2D<float4> lens : register(t0);
sampler lensSampler : register(s0);

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float zoomx;
	float zoomy;
	float fBase;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float width = fBase+lens.Sample(lensSampler,In.texCoord).r*zoomx * In.Tint.r;
	float height = fBase+lens.Sample(lensSampler,In.texCoord).r*zoomy * In.Tint.r;
	In.texCoord.x += (width-1.0f)/2.0;
	In.texCoord.y += (height-1.0f)/2.0;
	return bg.Sample(bgSampler,float2(In.texCoord.x/width,In.texCoord.y/height));
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 tc = lens.Sample(lensSampler,In.texCoord) * In.Tint;
	if ( tc.a != 0 )
		tc.r /= tc.a;
	float width = fBase+tc.r*zoomx;
	float height = fBase+tc.r*zoomy;
	In.texCoord.x += (width-1.0f)/2.0;
	In.texCoord.y += (height-1.0f)/2.0;
	return bg.Sample(bgSampler,float2(In.texCoord.x/width,In.texCoord.y/height));
}
