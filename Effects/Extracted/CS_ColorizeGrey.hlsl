
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
	//Tint color
	float4 fTint;
	float fCoeff;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord);
	
	if(Out.Color.r>Out.Color.g-fCoeff &&
		Out.Color.r<Out.Color.g+fCoeff &&
		Out.Color.r>Out.Color.b-fCoeff &&
		Out.Color.r<Out.Color.b+fCoeff)
	{
		Out.Color.rgb = Out.Color.rgb*fTint.rgb;
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
	Out.Color = GetColorPM(In.texCoord);
	
	if(Out.Color.r>Out.Color.g-fCoeff &&
		Out.Color.r<Out.Color.g+fCoeff &&
		Out.Color.r>Out.Color.b-fCoeff &&
		Out.Color.r<Out.Color.b+fCoeff)
	{
		Out.Color.rgb = Out.Color.rgb*fTint.rgb;
	}
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
	
    return Out;
}

