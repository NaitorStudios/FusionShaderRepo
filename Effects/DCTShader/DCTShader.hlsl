/***********************************************************/
/* Samplers */
/***********************************************************/

Texture2D<float4> S2D_Image : register(t0);
SamplerState S2D_ImageSampler : register(s0);

/***********************************************************/
/* Varibles */
/***********************************************************/

cbuffer PS_VARIABLES : register(b0)
{
    float EffectAmount;
    float Time;
};

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

cbuffer PS_PIXELSIZE : register(b1)
{
    float fPixelWidth; // returns 1.0 / texture width
    float fPixelHeight; // returns 1.0 / texture height
};

/************************************************************/
/* Main */
/************************************************************/

#define STEPS (.5 + 3.0 * (.5 + 0.5 * sin(Time)))
#define PI 3.14159265359
#define SQRT2 0.70710678118

static const float mdct[64] = {
    0.4903926402, 0.4619397900, 0.4157348066, 0.3535533906,
    0.2777851165, 0.1913417162, 0.0980171403, 0.0,
    0.0980171403, 0.1913417162, 0.2777851165, 0.3535533906,
    0.4157348066, 0.4619397900, 0.4903926402, 0.5,
    0.4903926402, 0.4619397900, 0.4157348066, 0.3535533906,
    0.2777851165, 0.1913417162, 0.0980171403, 0.0,
    0.0980171403, 0.1913417162, 0.2777851165, 0.3535533906,
    0.4157348066, 0.4619397900, 0.4903926402, 0.5,
    0.4903926402, 0.4619397900, 0.4157348066, 0.3535533906,
    0.2777851165, 0.1913417162, 0.0980171403, 0.0,
    0.0980171403, 0.1913417162, 0.2777851165, 0.3535533906,
    0.4157348066, 0.4619397900, 0.4903926402, 0.5,
    0.4903926402, 0.4619397900, 0.4157348066, 0.3535533906,
    0.2777851165, 0.1913417162, 0.0980171403, 0.0,
    0.0980171403, 0.1913417162, 0.2777851165, 0.3535533906,
    0.4157348066, 0.4619397900, 0.4903926402, 0.5
};



float3 dct_h(float2 In)
{
    float2 grid = floor(In / (8.0 * float2(fPixelWidth, fPixelHeight))) * (8.0 * float2(fPixelWidth, fPixelHeight));
    float2 uv = frac(In / 8.0) * 8.0;
    float3 s = float3(0.0, 0.0, 0.0);
    for (int u = 0; u < 8; u++)
    {
        float3 c = S2D_Image.Sample(S2D_ImageSampler, grid + (float2(u, floor(uv.y)) + 0.5) / float2(fPixelWidth, fPixelHeight)).rgb;
        s += c * mdct[u * 8 + int(uv.x)];
    }
    return s;
}

float3 dct_v(float2 In)
{
    float2 grid = floor(In / (8.0 * float2(fPixelWidth, fPixelHeight))) * (8.0 * float2(fPixelWidth, fPixelHeight));
    float2 uv = frac(In / 8.0) * 8.0;
    float3 s = float3(0.0, 0.0, 0.0);
    for (int v = 0; v < 8; v++)
    {
        float3 c = S2D_Image.Sample(S2D_ImageSampler, grid + (float2(floor(uv.x), v) + 0.5) * float2(fPixelWidth, fPixelHeight) ).rgb;
        s += c * mdct[v * 8 + int(uv.y)];
    }
    return s;
}

float3 idct_h(float2 In)
{
    float2 grid = floor(In / (8.0 * float2(fPixelWidth, fPixelHeight))) * (8.0 * float2(fPixelWidth, fPixelHeight));
    float2 uv = frac(In / 8.0) * 8.0;
    float3 s = float3(0.0, 0.0, 0.0);
    for (int u = 0; u < 8; u++)
    {
        float3 c = S2D_Image.Sample(S2D_ImageSampler, grid + (float2(u, floor(uv.y)) + 0.5)*  float2(fPixelWidth, fPixelHeight)).rgb;
        s += c * mdct[u * 8 + int(uv.x)];
    }
    return s;
}

float3 idct_v(float2 In)
{
    float2 grid = floor(In / (8.0 * float2(fPixelWidth, fPixelHeight))) * (8.0 * float2(fPixelWidth, fPixelHeight));
    float2 uv = frac(In / 8.0) * 8.0;
    float3 s = float3(0.0, 0.0, 0.0);
    for (int v = 0; v < 8; v++)
    {
        float3 c = S2D_Image.Sample(S2D_ImageSampler, grid + (float2(floor(uv.x), v) + 0.5) * float2(fPixelWidth, fPixelHeight)).rgb;
        s += c * mdct[v * 8 + int(uv.y)];
    }
    return s;
}


PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;

    //float4 _Render_Texture = S2D_Image.Sample(S2D_ImageSampler, In.texCoord) * In.Tint;

        float3 col = dct_v(In.texCoord) * 0.25;
        col = round(col * STEPS) / STEPS;

    Out.Color = float4(col * EffectAmount, 1.0);
    return Out;
}

/************************************************************/
/* Premultiplied Alpha */
/************************************************************/
/*
float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In ) 
{
    PS_OUTPUT Out;

    //float4 _Render_Texture = S2D_Image.Sample(S2D_ImageSampler, In.texCoord) * In.Tint;

    float STEPS = (0.5 + 3.0 * (0.5 + 0.5 * sin(Time)));

        float3 col = dct_v(In.texCoord) * 0.25;
        col = round(col * STEPS) / STEPS;

    col.rgb *= col.a;

    Out.Color = _Result;
    return Out;
}*/