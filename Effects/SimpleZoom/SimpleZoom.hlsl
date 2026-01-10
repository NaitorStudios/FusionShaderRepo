Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

struct PS_INPUT {
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
};

cbuffer PS_VARIABLES : register(b0) {
    float zoom;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET {
    In.texCoord = (In.texCoord-0.5)/zoom+0.5;
    return bg.Sample(bgSampler, In.texCoord) * In.Tint;
}