// Pixel shader input structure
struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
    int mask_x;
    int mask_y;
    int mask_width;
    int mask_height;
};

cbuffer PS_PIXELSIZE : register(b1)
{
    float fPixelWidth;
    float fPixelHeight;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> masktex : register(t1);
sampler masktexSampler : register(s1);

float4 effect(PS_INPUT In, bool PM) : SV_TARGET
{
    float4 maintexture = Tex0.Sample(Tex0Sampler, In.texCoord);

    // Calculate UVs relative to the mask region
    float2 maskUV = float2(
        (In.texCoord.x / fPixelWidth - mask_x) / mask_width,
        (In.texCoord.y / fPixelHeight - mask_y) / mask_height
    );

    // Clamp UVs to avoid sampling outside
    maskUV = saturate(maskUV);

    float4 masktexture = masktex.Sample(masktexSampler, maskUV);

    // Use luminance of RGB as alpha
    float maskAlpha = dot(masktexture.rgb, float3(0.299, 0.587, 0.114));

    // Blend from black to maintexture
    float4 color = lerp(0, maintexture, maskAlpha);

    if (PM)
        color.rgb *= color.a;

    return color * In.Tint;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET {
    return effect(In, false);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET {
    return effect(In, true);
}
