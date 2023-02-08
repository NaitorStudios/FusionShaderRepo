// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> Palettes : register(t1);
sampler PalettesSampler : register(s1);

cbuffer PS_VARIABLES:register(b0)
{
	int nPal, lerpA, lerpB;
	float lerpVal;
}


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 output =  img.Sample(imgSampler, In.texCoord);
	float index = img.Sample(imgSampler, In.texCoord).r;

	float odd = float(nPal) % 2;
	float4 colorA = Palettes.Sample(PalettesSampler, float2(index, (lerpA + odd) / float(nPal)));
	float4 colorB = Palettes.Sample(PalettesSampler, float2(index, (lerpB + odd) / float(nPal)));
	output = float4(lerp(colorA.xyz, colorB.xyz, lerpVal), output.a);
	
	return output * In.Tint;
}

float4 ps_main_pm(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 output =  img.Sample(imgSampler, In.texCoord);
	float index = img.Sample(imgSampler, In.texCoord).r;

	float odd = float(nPal) % 2;
	float4 colorA = Palettes.Sample(PalettesSampler, float2(index, (lerpA + odd) / float(nPal)));
	float4 colorB = Palettes.Sample(PalettesSampler, float2(index, (lerpB + odd) / float(nPal)));
	output = float4(lerp(colorA.xyz, colorB.xyz, lerpVal), output.a);
	
	output.rgb *= output.a;
	
	return output * In.Tint;
}


