
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
Texture2D<float4> Tex0 : register(t1);
sampler Tex0Sampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float fOffset;
	float fCoeff;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
	float _fCoeff = fCoeff * 1.001;
	if(_fCoeff > 0) {
	Out.Color.r = uint((Out.Color.r+fOffset)/_fCoeff*255)/255*_fCoeff;
	Out.Color.g = uint((Out.Color.g+fOffset)/_fCoeff*255)/255*_fCoeff;
	Out.Color.b = uint((Out.Color.b+fOffset)/_fCoeff*255)/255*_fCoeff;
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

    Out.Color = GetColorPM( In.texCoord, In.Tint);
	float _fCoeff = fCoeff * 1.001;
	if(_fCoeff > 0) {
	Out.Color.r = uint((Out.Color.r+fOffset)/_fCoeff*255)/255*_fCoeff;
	Out.Color.g = uint((Out.Color.g+fOffset)/_fCoeff*255)/255*_fCoeff;
	Out.Color.b = uint((Out.Color.b+fOffset)/_fCoeff*255)/255*_fCoeff;
	}
	Out.Color.rgb *= Out.Color.a;
    return Out;
}
