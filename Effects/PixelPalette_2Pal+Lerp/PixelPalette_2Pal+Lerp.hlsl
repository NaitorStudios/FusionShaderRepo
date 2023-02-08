// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

Texture2D<float4> PaletteA : register(t1);
sampler PaletteASampler : register(s1);

Texture2D<float4> PaletteB : register(t2);
sampler PaletteBSampler : register(s2);

cbuffer PS_VARIABLES:register(b0)
{
	float lerpVal;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 output;

	float texChannelRed = Demultiply( Tex0.Sample(Tex0Sampler, In.texCoord) *In.Tint ).r;
	float4 colorA = PaletteA.Sample(PaletteASampler, float2(texChannelRed, 0));
	float4 colorB = PaletteB.Sample(PaletteBSampler, float2(texChannelRed, 0));

	output = lerp(colorA, colorB, lerpVal);
	output.a = Tex0.Sample(Tex0Sampler, In.texCoord).a;

	return output;
}

float4 ps_main_pm(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 output;

	float texChannelRed = Demultiply( Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint ).r;
	float4 colorA = PaletteA.Sample(PaletteASampler, float2(texChannelRed, 0));
	float4 colorB = PaletteB.Sample(PaletteBSampler, float2(texChannelRed, 0));

	output = lerp(colorA, colorB, lerpVal);
	output.a = Tex0.Sample(Tex0Sampler, In.texCoord).a;
	
	output.rgb *= output.a;

	return output;
}
