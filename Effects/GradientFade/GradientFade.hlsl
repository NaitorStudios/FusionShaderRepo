
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float minY;
	float maxY;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET	{
float rangeY = maxY - minY;
float4 newColor = Demultiply(img.Sample( imgSampler, In.texCoord ))*In.Tint;
newColor.a = min(1.0-(In.texCoord.y - minY) / rangeY, newColor.a);
return newColor;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET	{
float rangeY = maxY - minY;
float4 newColor = Demultiply(img.Sample( imgSampler, In.texCoord ))*In.Tint;
newColor.a = min(1.0-(In.texCoord.y - minY) / rangeY, newColor.a);
newColor.rgb *= newColor.a;
return newColor;
}
