Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

#define samples 60

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0) {
	bool BG;
	float intensity;
	float angle;
};

float4 ps_main(PS_INPUT In) : SV_TARGET { 
	float4 col = 0;
	float _angle = angle*0.0174532925f;

	for(float i=0; i<samples;i++){
		float2 uv = In.texCoord + float2(cos(_angle)*intensity*(i/samples-0.5),sin(_angle)*intensity*(i/samples-0.5));

		if(BG) col += bg.Sample(bgSampler, uv)*In.Tint;
		else col += img.Sample(imgSampler, uv)*In.Tint;
	}

	col /= samples;
	return col;
}