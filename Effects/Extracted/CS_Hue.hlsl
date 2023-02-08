
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
	float fHue;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	PS_OUTPUT Init;
	
	Init.Color = Tex0.Sample(Tex0Sampler, In.texCoord);
    Out.Color.a = Init.Color.a;
	
	if( fHue < 1.0f )
	{
		Out.Color.r = Init.Color.r+(Init.Color.g-Init.Color.r)*fHue;
		Out.Color.g = Init.Color.g+(Init.Color.b-Init.Color.g)*fHue;
		Out.Color.b = Init.Color.b+(Init.Color.r-Init.Color.b)*fHue;
	}
	else if( fHue >= 1.0f && fHue < 2.0 )
	{
		Out.Color.r = Init.Color.g+(Init.Color.b-Init.Color.g)*(fHue-1.0f);
		Out.Color.g = Init.Color.b+(Init.Color.r-Init.Color.b)*(fHue-1.0f);
		Out.Color.b = Init.Color.r+(Init.Color.g-Init.Color.r)*(fHue-1.0f);
	}
	else if( fHue >= 2.0f )
	{
		Out.Color.r = Init.Color.b+(Init.Color.r-Init.Color.b)*(fHue-2.0f);
		Out.Color.g = Init.Color.r+(Init.Color.g-Init.Color.r)*(fHue-2.0f);
		Out.Color.b = Init.Color.g+(Init.Color.b-Init.Color.g)*(fHue-2.0f);
	}
	Out.Color *= In.Tint;

    return Out;
}

float4 GetColorPM(float2 xy)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	PS_OUTPUT Init;
	
	Init.Color = GetColorPM(In.texCoord);
    Out.Color.a = Init.Color.a;
	
	if( fHue < 1.0f )
	{
		Out.Color.r = Init.Color.r+(Init.Color.g-Init.Color.r)*fHue;
		Out.Color.g = Init.Color.g+(Init.Color.b-Init.Color.g)*fHue;
		Out.Color.b = Init.Color.b+(Init.Color.r-Init.Color.b)*fHue;
	}
	else if( fHue >= 1.0f && fHue < 2.0 )
	{
		Out.Color.r = Init.Color.g+(Init.Color.b-Init.Color.g)*(fHue-1.0f);
		Out.Color.g = Init.Color.b+(Init.Color.r-Init.Color.b)*(fHue-1.0f);
		Out.Color.b = Init.Color.r+(Init.Color.g-Init.Color.r)*(fHue-1.0f);
	}
	else if( fHue >= 2.0f )
	{
		Out.Color.r = Init.Color.b+(Init.Color.r-Init.Color.b)*(fHue-2.0f);
		Out.Color.g = Init.Color.r+(Init.Color.g-Init.Color.r)*(fHue-2.0f);
		Out.Color.b = Init.Color.g+(Init.Color.b-Init.Color.g)*(fHue-2.0f);
	}
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;

    return Out;
}

