
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

Texture2D<float4> Bkd : register(t1);
sampler BkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	uniform float fOffset;
	uniform float fR;
	uniform float fG;
	uniform float fB;
    bool BG;
};

PS_OUTPUT ps_main(in PS_INPUT In)
{
    // Output pixel
    PS_OUTPUT Out;

    float4 col = BG ? Bkd.Sample(BkdSampler, In.texCoord) : Tex0.Sample(Tex0Sampler, In.texCoord);

    float _fR = fR * 1.001;
    float _fG = fG * 1.001;
    float _fB = fB * 1.001;

    if(_fR > 0) col.r = uint((col.r + fOffset) / _fR * 255) / 255 * _fR;
    if(_fG > 0) col.g = uint((col.g + fOffset) / _fG * 255) / 255 * _fG;
    if(_fB > 0) col.b = uint((col.b + fOffset) / _fB * 255) / 255 * _fB;

    Out.Color = col;
    return Out;
}
/*
float4 GetColorPM(float2 xy, float4 tint)
{
    float4 color;

    if (BG == 1)
        color = Bkd.Sample(BkdSampler, xy) * tint;
    else
        color = Tex0.Sample(Tex0Sampler, xy) * tint;

    if (color.a > 0.0)
        color.rgb /= color.a;

    return color;
}

PS_OUTPUT ps_main_pm(in PS_INPUT In)
{
    PS_OUTPUT Out;

    float2 uv = In.texCoord;

    float2 bkd_uv = float2(uv.x, uv.y);

    float4 col = BG ? GetColorPM(bkd_uv, In.Tint) : GetColorPM(uv, In.Tint);

    float _fR = fR * 1.001;
    float _fG = fG * 1.001;
    float _fB = fB * 1.001;

    if(_fR > 0) col.r = uint((col.r + fOffset) / _fR * 255) / 255 * _fR;
    if(_fG > 0) col.g = uint((col.g + fOffset) / _fG * 255) / 255 * _fG;
    if(_fB > 0) col.b = uint((col.b + fOffset) / _fB * 255) / 255 * _fB;

    col.rgb *= col.a;

    Out.Color = col;
    return Out;
}
*/