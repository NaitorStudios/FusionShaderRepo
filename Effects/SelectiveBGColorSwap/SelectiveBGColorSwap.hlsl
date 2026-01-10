struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0); // The sprite's texture.
SamplerState imgSampler : register(s0);

Texture2D<float4> bkd : register(t1); // The background's texture.
SamplerState bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
    float4 RGB1; // The color you want to detect.
    float4 RGB2; // The color you want to replace with.
};

float4 Demultiply(float4 _color)
{
    float4 color = _color;
    if (color.a != 0)
        color.rgb /= color.a;
    return color;
}

float4 effect(in PS_INPUT In, bool PM) : SV_TARGET
{
    // Sample the sprite's color.
    float4 spriteColor = Demultiply(img.Sample(imgSampler, In.texCoord) * In.Tint);
	spriteColor.rgb *= In.Tint.rgb;
    float4 o = spriteColor;
    
    // Sample the background's color.
    float4 bgColor = bkd.Sample(bkdSampler, In.texCoord);
    
    // Check if the background color exactly matches RGB1.
    if (all(bgColor.rgb == RGB1.rgb)) {
        o = float4(RGB2.rgb, spriteColor.a); // Replace with RGB2 color.
    }
	
    // Apply premultiplied alpha if needed
    if (PM)
        o.rgb *= o.a;
    
    // Return the result.
    return o;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    return effect(In, false);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    return effect(In, true);
}


