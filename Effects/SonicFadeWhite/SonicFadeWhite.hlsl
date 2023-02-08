struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> Texture0 : register(t0);
sampler Texture0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	// IMPORTANT: the parameters must be in the same order as in your XML file
	float time;
	float4 a;
	float4 b;
	float4 c;
};

static float STEP = 1/3.0f;

float4 ps_main(in PS_INPUT In) : SV_TARGET
{ 
	//Source color
	float4 ret = Texture0.Sample(Texture0Sampler,In.texCoord) * In.Tint;
	float3 fade = 1.0f;

	//Step A: black to A
	if(time < STEP)
	{
		fade = lerp(c.rgb, a.rgb, (time/STEP));
	}
	//Step B: A to B
	else if(time >= STEP && time <= 2*STEP)
	{
		fade = lerp(a.rgb, b.rgb, (time-STEP)/STEP);
	}
	//Step C: B to white
	else if(time < 1)
	{
		fade = 1 - (1-b.rgb)*((1-time)/STEP);
	}

	//Apply fade
	ret.rgb += fade;
	return ret;
}
