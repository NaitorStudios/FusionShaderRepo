// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

// Alpha Threshold effect

cbuffer PS_VARIABLES : register(b0)
{
	float s;
}


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}


float4 ps_main(PS_INPUT In) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample( Tex0Sampler, In.texCoord )) * In.Tint;
	if (color.a < s)
		color.a = 0.0;
	else
		color.a = 1.0;
	
	return color ;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample( Tex0Sampler, In.texCoord )) * In.Tint;
	if (color.a < s)
		color.a = 0.0;
	else
		color.a = 1.0;
	
	color.rgb *= color.a;
	return color;
}
