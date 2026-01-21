
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
	int iR=0;
	int iG=0;
	int iB=0;
	int iA=0;
	float iFr=1;
	float iFg=1;
	float iFb=1;
	float iFa=1;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
	float channels[4];

	// Output pixel
    PS_OUTPUT Out;
    Out.Color = Texture0.Sample(Texture0Sampler,In.texCoord) * In.Tint;
    channels[0] = Out.Color.r;
    channels[1] = Out.Color.g;
    channels[2] = Out.Color.b;
    channels[3] = Out.Color.a;
    
    Out.Color.r = Out.Color.r+(channels[iR]-Out.Color.r)*iFr;
    Out.Color.g = Out.Color.g+(channels[iG]-Out.Color.g)*iFg;
    Out.Color.b = Out.Color.b+(channels[iB]-Out.Color.b)*iFb;
    Out.Color.a = Out.Color.a+(channels[iA]-Out.Color.a)*iFa;
    
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
	float channels[4];

	// Output pixel
    PS_OUTPUT Out;
    Out.Color = GetColorPM(In.texCoord, In.Tint);
    channels[0] = Out.Color.r;
    channels[1] = Out.Color.g;
    channels[2] = Out.Color.b;
    channels[3] = Out.Color.a;
    
    Out.Color.r = Out.Color.r+(channels[iR]-Out.Color.r)*iFr;
    Out.Color.g = Out.Color.g+(channels[iG]-Out.Color.g)*iFg;
    Out.Color.b = Out.Color.b+(channels[iB]-Out.Color.b)*iFb;
    Out.Color.a = Out.Color.a+(channels[iA]-Out.Color.a)*iFa;
	Out.Color.rgb *= Out.Color.a;
    
    return Out;
}
