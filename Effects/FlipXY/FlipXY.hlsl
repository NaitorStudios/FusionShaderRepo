
struct PS_INPUT 
{
    float4 Tint     : COLOR0;
    float2 texCoord : TEXCOORD0;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

float4 Demultiply(float4 _color)
{
    float4 color = _color;
    if ( color.a != 0)
        color.xyz /= color.a;
    return color;
}

float4 effect(PS_INPUT In, bool PM) : SV_Target
{
    float4 Out = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord)); 
    Out.rgba = Tex0.Sample(Tex0Sampler, float2(1.0-In.texCoord.x,1.0-In.texCoord.y));

    if (PM)
        Out.rgb *= Out.a;
    
    return Out * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
    return effect(In, false);
}

// For pre-multiplied alpha
float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
    return effect(In, true);
}