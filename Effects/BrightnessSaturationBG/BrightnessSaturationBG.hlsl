
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> source : register(t1);
sampler sourceSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float Saturation;
	float Brightness;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 color = source.Sample(sourceSampler,In.texCoord) * In.Tint;
	
	float f = (color.r+color.g+color.b)/3;
	color.rgb = Brightness+f*(1.0f-Saturation)+color.rgb*Saturation;

	return color;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float4 color = source.Sample(sourceSampler,In.texCoord) * In.Tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	
	float f = (color.r+color.g+color.b)/3;
	color.rgb = Brightness+f*(1.0f-Saturation)+color.rgb*Saturation;

	color.rgb *= color.a;
	return color;
}

