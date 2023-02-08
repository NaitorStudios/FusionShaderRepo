
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
	float fX;
	float fY;
	float4 fC;
	float fA;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    PS_OUTPUT Shade;
    Out.Color = Texture0.Sample(Texture0Sampler,In.texCoord) * In.Tint;
    Shade.Color = Texture0.Sample(Texture0Sampler,float2(In.texCoord.x-fX,In.texCoord.y-fY)) * In.Tint;
		Shade.Color.a *= fA;
		Shade.Color.rgb = fC.rgb;
		if(Out.Color.a < 1) {
			Out.Color.r += (Shade.Color.r-Out.Color.r)*(1-Out.Color.a);
			Out.Color.g += (Shade.Color.g-Out.Color.g)*(1-Out.Color.a);
			Out.Color.b += (Shade.Color.b-Out.Color.b)*(1-Out.Color.a);
			Out.Color.a += (Shade.Color.a-Out.Color.a)*(1-Out.Color.a);
		}
	
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
    PS_OUTPUT Shade;
    Out.Color = GetColorPM(In.texCoord, In.Tint);
    Shade.Color = GetColorPM(float2(In.texCoord.x-fX,In.texCoord.y-fY), In.Tint);
		Shade.Color.a *= fA;
		Shade.Color.rgb = fC.rgb;
		if(Out.Color.a < 1) {
			Out.Color.r += (Shade.Color.r-Out.Color.r)*(1-Out.Color.a);
			Out.Color.g += (Shade.Color.g-Out.Color.g)*(1-Out.Color.a);
			Out.Color.b += (Shade.Color.b-Out.Color.b)*(1-Out.Color.a);
			Out.Color.a += (Shade.Color.a-Out.Color.a)*(1-Out.Color.a);
		}
	
	Out.Color.rgb *= Out.Color.a;
    return Out;
}
