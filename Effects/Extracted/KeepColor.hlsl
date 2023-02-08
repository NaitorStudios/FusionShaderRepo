struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> source : register(t0);
sampler sourceSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float4 keep;
	float4 replace;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	//Read the color of the source texture at the current position (In)
	float4 color = source.Sample(sourceSampler,In.texCoord) * In.Tint;
	
	//Really, HLSL? Are you that stupid?
	if(color.r != keep.r || color.g != keep.g || color.b != keep.b)
		color.rgb = replace.rgb;

	//Output the color
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	//Read the color of the source texture at the current position (In)
	float4 color = source.Sample(sourceSampler,In.texCoord) * In.Tint;
	
	//Really, HLSL? Are you that stupid?
	if(color.r != keep.r || color.g != keep.g || color.b != keep.b)
		color.rgb = replace.rgb * color.a;

	//Output the color
	return color;
}

