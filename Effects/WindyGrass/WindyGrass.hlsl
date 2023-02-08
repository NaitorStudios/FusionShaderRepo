
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);


cbuffer PS_VARIABLES : register(b0)
{
	float intensity;
	float time;
	float timeCoef;
	float opacity;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT UV ) : SV_TARGET
{
	UV.texCoord.x -= ((UV.texCoord.y-0.9) * intensity)*sin((time*timeCoef) + (10*(cos(UV.texCoord.y)+3)));
	
	float4 Out = Demultiply(img.Sample(imgSampler, UV.texCoord.xy) * UV.Tint);
	Out.a = lerp(0.0, Out.a, opacity);
	return Out;
}

float4 ps_main_pm( in PS_INPUT UV ) : SV_TARGET
{
	UV.texCoord.x -= ((UV.texCoord.y-0.9) * intensity)*sin((time*timeCoef) + (10*(cos(UV.texCoord.y)+3)));
	
	float4 Out = Demultiply(img.Sample(imgSampler, UV.texCoord.xy) * UV.Tint);
	Out.a = lerp(0.0, Out.a, opacity);
	Out.rgb *= Out.a;
	return Out;
}

