// Pixel shader input structure
struct PS_INPUT
{
    float4 Tint     : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

// Global variables
Texture2D Tex0         : register(t0);
SamplerState Tex0Sampler : register(s0);

Texture2D bg             : register(t1);
SamplerState bgSampler   : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
    float4 fTarget;    // Target color
    float  fTolerance; // Tolerance percent
    int    fAnimation; // Switch to use animation frame as tint
    float4 fTint;      // Replacement color
    int    fBlend;     // Enable blending
    int    fInvert;    // Invert the effect
}

float4 Demultiply(float4 _color)
{
    float4 color = _color;
    if (color.a != 0)
        color.rgb /= color.a;
    return color;
}

float4 effect(in PS_INPUT In, bool PM) : SV_TARGET
{
    // Sample the background texture
    float4 BgColor = bg.Sample(bgSampler, In.texCoord);

    // Sample the object's texture and multiply by vertex tint
    float4 ObjTexColor = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;

    // Demultiply the color if necessary
    float4 DemultipliedColor = Demultiply(ObjTexColor);

    // Determine the tint color
    float fAnim = (float)fAnimation; // Convert int to float (0.0f or 1.0f)
    float3 RealTintRGB = lerp(fTint.rgb, DemultipliedColor.rgb, fAnim);
    float  RealTintAlpha = ObjTexColor.a; // Use the alpha from the object's texture
    float4 RealTint = float4(RealTintRGB, RealTintAlpha);

    // Compute the difference between the background color and target color
    float3 TargetColor = fTarget.rgb;
    float  Difference = 1.0f - saturate(dot(abs(BgColor.rgb - TargetColor), 1.0f / 3.0f));

    // Calculate blending factor based on tolerance
    float Blending = saturate((Difference - fTolerance) / (1.0f - fTolerance));

    // Create a mask for pixels that meet the tolerance criteria
    float Mask = step(fTolerance, Difference);

    // Invert the mask if fInvert is true
    if (fInvert != 0)
    {
        Mask = 1.0f - Mask;
    }

    // Determine if blending or replacing is needed
    float BlendFactor = fBlend != 0 ? Blending * Mask : Mask;

    // Linearly interpolate between the background color and the tint color
    float4 OutColor;
    OutColor.rgb = lerp(BgColor.rgb, RealTint.rgb, BlendFactor);
    OutColor.a   = lerp(BgColor.a,   RealTint.a,   BlendFactor);

    // Apply premultiplied alpha if needed
    if (PM)
        OutColor.rgb *= OutColor.a;

    return OutColor;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    return effect(In, false);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    return effect(In, true);
}
