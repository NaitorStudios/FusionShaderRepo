
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
	float fSeed;
	float fStrength;
	bool iR;
	bool iG;
	bool iB;
	bool iA;
	bool iInvert;
};

/* Random algorithm by Sylvain Lefebvre */

#define M_PI 3.14159265358979323846

float mccool_rand(float2 ij) {
  const float4 a=float4(pow(M_PI,4),exp(5),pow(13, M_PI / 2.0),sqrt(1997.0));
  float4 result =float4(ij,ij);

  for(int i = 0; i < 3; i++) {
		result.x = frac(dot(result, a));
		result.y = frac(dot(result, a));
		result.z = frac(dot(result, a));
		result.w = frac(dot(result, a));
  }
  return (float)result.xy;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
  	Out.Color = Texture0.Sample(Texture0Sampler,In.texCoord) * In.Tint;
  	float rand = mccool_rand(In.texCoord+fSeed)*fStrength; rand = iInvert ? 1-rand : rand;
		if(iR) Out.Color.r *= rand;
		if(iG) Out.Color.g *= rand;
		if(iB) Out.Color.b *= rand;
		if(iA) Out.Color.a *= rand;
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
  	Out.Color = GetColorPM(In.texCoord, In.Tint);
  	float rand = mccool_rand(In.texCoord+fSeed)*fStrength; rand = iInvert ? 1-rand : rand;
		if(iR) Out.Color.r *= rand;
		if(iG) Out.Color.g *= rand;
		if(iB) Out.Color.b *= rand;
		if(iA) Out.Color.a *= rand;
	Out.Color.rgb *= Out.Color.a;
    return Out;
}
