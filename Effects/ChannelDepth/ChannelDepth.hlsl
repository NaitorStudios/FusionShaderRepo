
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
	float fOffset;
	float fR;
	float fG;
	float fB;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
	float _fR = fR * 1.001;
	float _fG = fG * 1.001;
	float _fB = fB * 1.001;
	if(_fR>0) Out.Color.r = uint((Out.Color.r+fOffset)/_fR*255)/255*_fR;
	if(_fG>0) Out.Color.g = uint((Out.Color.g+fOffset)/_fG*255)/255*_fG;
	if(_fB>0) Out.Color.b = uint((Out.Color.b+fOffset)/_fB*255)/255*_fB;
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

    Out.Color = GetColorPM(In.texCoord, In.Tint);
	float _fR = fR * 1.001;
	float _fG = fG * 1.001;
	float _fB = fB * 1.001;
	if(_fR>0) Out.Color.r = uint((Out.Color.r+fOffset)/_fR*255)/255*_fR;
	if(_fG>0) Out.Color.g = uint((Out.Color.g+fOffset)/_fG*255)/255*_fG;
	if(_fB>0) Out.Color.b = uint((Out.Color.b+fOffset)/_fB*255)/255*_fB;
	Out.Color.rgb *= Out.Color.a;
    return Out;
}
