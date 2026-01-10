// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Texture0 : register(s0);

float fProgress;
float fZoom;
float fOffsetX;
float fOffsetY;
float fWarp; 

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

const float2x2 mtx = float2x2(0.80, 0.60, -0.60, 0.80);

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

    // f += 0.062500 * noise(p);
    // p = mul(mtx, p) * 2.04;

    f += 0.015625 * noise(p + float2(fProgress, fProgress));

    return f / 0.96875;
}

float pattern(float2 p)
{
    return fbm(p);
    //return fbm(p + fbm(p + fbm(p)));
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float2 uv = In.Texture * fZoom + float2(fOffsetX, fOffsetY);
    float2 warp = (noise(uv + float2(fProgress, fProgress)) - 0.5) * fWarp;
    uv += warp;
    float shade = max(0.2, pattern(uv));;
    Out.Color = float4(shade * tex2D(Texture0, In.Texture).r, shade * tex2D(Texture0, In.Texture).g , shade * tex2D(Texture0, In.Texture).b, 1.0);
    return Out;
}

technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }  
}