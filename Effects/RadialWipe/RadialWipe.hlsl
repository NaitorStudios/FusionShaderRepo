struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
SamplerState Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
    float progress;
    float feather;
}

float4 Demultiply(float4 _color)
{
    float4 color = _color;
    if (color.a != 0)
        color.rgb /= color.a;
    return color;
}

static const float2 center = float2(0.5, 0.5);

float4 ps_main(in PS_INPUT In) : SV_Target
{
    float4 color = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord)) ;
    float2 dir = normalize(center - In.texCoord);
    float d = dot(dir, center);
    float m =
        (1.0 - step(progress, 0.0)) *
        (1.0 - smoothstep(-feather, 0.0, dot(dir, In.texCoord) - (d - 0.5 + progress * (1.0 + feather))));
    float alpha = lerp(color.a, 0.0, m);
    color.a = alpha;
    return color * In.Tint;
}

float4 ps_main_pm(in PS_INPUT In) : SV_Target
{
    float4 color = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord));
    float2 dir = normalize(center - In.texCoord);
    float d = dot(dir, center);
    float m =
        (1.0 - step(progress, 0.0)) *
        (1.0 - smoothstep(-feather, 0.0, dot(dir, In.texCoord) - (d - 0.5 + progress * (1.0 + feather))));
    float alpha = lerp(color.a, 0.0, m);
    color.a = alpha;
    color.rgb *= color.a;
    return color * In.Tint;
}
