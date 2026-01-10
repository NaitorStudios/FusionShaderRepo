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
    float4 Color : SV_TARGET;
};

// Global variables
Texture2D<float4> Texture0 : register(t1);
sampler Texture0Sampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
    float fProgress;
    float fZoom;
	float fOffsetX;
    float fOffsetY;
	float fWarp;
};

float rand(float2 n) {
    return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453);
}

float noise(float2 p) {
    float2 ip = floor(p);
    float2 u = frac(p);
    u = u * u * (3.0 - 2.0 * u);

    float res = lerp(
        lerp(rand(ip), rand(ip + float2(1.0, 0.0)), u.x),
        lerp(rand(ip + float2(0.0, 1.0)), rand(ip + float2(1.0, 1.0)), u.x),
        u.y
    );
    return res * res;
}

static const float2x2 mtx = float2x2(0.80, 0.60, -0.60, 0.80);

float fbm(float2 p)
{
    float f = 0.0;

    f += 0.500000 * noise(p + float2(fProgress, fProgress));
    p = mul(mtx, p) * 2.02;

    f += 0.031250 * noise(p);
    p = mul(mtx, p) * 2.01;

    f += 0.250000 * noise(p);
    p = mul(mtx, p) * 2.03;

    f += 0.125000 * noise(p);
    p = mul(mtx, p) * 2.01;

    f += 0.062500 * noise(p);
    p = mul(mtx, p) * 2.04;

    f += 0.015625 * noise(p + float2(fProgress, fProgress));

    return f / 0.96875;
}

float pattern(float2 p)
{
    return fbm(p + fbm(p + fbm(p)));
}

PS_OUTPUT ps_main(in PS_INPUT In)
{
    PS_OUTPUT Out;
	float2 uv = In.texCoord * fZoom + float2(fOffsetX, fOffsetY);
	float2 warp = (noise(uv + float2(fProgress, fProgress)) - 0.5) * fWarp;
    uv += warp;
    float shade = max(0.2, pattern(uv));
    Out.Color = float4(shade * In.Tint.r, shade * In.Tint.g, shade * In.Tint.b, In.Tint.a);
    return Out;
}

PS_OUTPUT ps_main_pm(in PS_INPUT In)
{
    PS_OUTPUT Out;
	float2 uv = In.texCoord * fZoom + float2(fOffsetX, fOffsetY);
	float2 warp = (noise(uv + float2(fProgress, fProgress)) - 0.5) * fWarp;
    uv += warp;
    float shade = max(0.2, pattern(uv));
    float alpha = In.Tint.a;
    Out.Color = float4(shade * In.Tint.r * alpha, shade * In.Tint.g * alpha, shade * In.Tint.b * alpha, alpha);
    return Out;
}
