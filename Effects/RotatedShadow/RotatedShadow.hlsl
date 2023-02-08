
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
	float fAngle;
	float fRadius;
	float4 fC;
	float fA;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
	// Output pixel
	PS_OUTPUT Out;

	float _fAngle = fAngle*0.0174532925f;
	float dx = cos(_fAngle) * fRadius;
	float dy = sin(_fAngle) * fRadius;

	float2 dxyr;
	dxyr.x = dx - dy;
	dxyr.y = dx + dy;

	float4 Shade;

	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord.xy) * In.Tint;
	Shade = Tex0.Sample(Tex0Sampler,float2(In.texCoord.x-dxyr.x,In.texCoord.y-dxyr.y)) * In.Tint;
	Shade.a *= fA;
	Shade.rgb = fC.rgb;
	if(Out.Color.a < 1) {
		Out.Color.r += (Shade.r-Out.Color.r)*(1-Out.Color.a);
		Out.Color.g += (Shade.g-Out.Color.g)*(1-Out.Color.a);
		Out.Color.b += (Shade.b-Out.Color.b)*(1-Out.Color.a);
		Out.Color.a += (Shade.a-Out.Color.a)*(1-Out.Color.a);
	}
	return Out;
}

float4 GetColorPM(float2 xy, float4 tint)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
	// Output pixel
	PS_OUTPUT Out;

	float _fAngle = fAngle*0.0174532925f;
	float dx = cos(_fAngle) * fRadius;
	float dy = sin(_fAngle) * fRadius;

	float2 dxyr;
	dxyr.x = dx - dy;
	dxyr.y = dx + dy;

	float4 Shade;

	Out.Color = GetColorPM(In.texCoord.xy, In.Tint);
	Shade = GetColorPM(float2(In.texCoord.x-dxyr.x,In.texCoord.y-dxyr.y), In.Tint);
	Shade.a *= fA;
	Shade.rgb = fC.rgb;
	if(Out.Color.a < 1) {
		Out.Color.r += (Shade.r-Out.Color.r)*(1-Out.Color.a);
		Out.Color.g += (Shade.g-Out.Color.g)*(1-Out.Color.a);
		Out.Color.b += (Shade.b-Out.Color.b)*(1-Out.Color.a);
		Out.Color.a += (Shade.a-Out.Color.a)*(1-Out.Color.a);
	}

	Out.Color.rgb *= Out.Color.a;
	return Out;
}
