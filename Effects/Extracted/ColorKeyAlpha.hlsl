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
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float4 ColorKey;
	int  Tolerance;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample( Tex0Sampler , In.texCoord )) * In.Tint;
    if (all(abs(color.rgb - ColorKey.rgb) < asfloat(Tolerance))) {
        color.a = 0.0;
    }

    return color;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample( Tex0Sampler , In.texCoord )) * In.Tint;
    if (all(abs(color.rgb - ColorKey.rgb) < asfloat(Tolerance))) {
        color.a = 0.0;
    }
	
	color.rgb *= color.a;
    return color;
}


