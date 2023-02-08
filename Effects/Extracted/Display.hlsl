
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
Texture2D<float4> Texture0 : register(t0);
sampler Texture0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fAmplitude;
	float fPeriods;
	float fOffset;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = Texture0.Sample(Texture0Sampler,In.texCoord.xy) * In.Tint;
    Out.Color.rgb += sin(In.texCoord.y*fPeriods-fOffset)*fAmplitude;
    return Out;
}

float4 GetColorPM(float2 xy, float4 tint)
{
	float4 color = Texture0.Sample(Texture0Sampler, xy) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = GetColorPM(In.texCoord.xy, In.Tint);
    Out.Color.rgb += sin(In.texCoord.y*fPeriods-fOffset)*fAmplitude;
	Out.Color.rgb *= Out.Color.a;
    return Out;
}
