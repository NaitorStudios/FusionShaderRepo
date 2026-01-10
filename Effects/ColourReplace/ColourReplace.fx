// Pixel shader input structure
struct PS_INPUT
{
    float4 Position : POSITION;
    float2 Texture  : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

// Global variables
sampler2D Tex0;
sampler2D bg : register(s1);

float3 fTarget;      // Target color
float  fTolerance;   // Tolerance percent
bool   fAnimation;   // Switch to use animation frame as tint
float3 fTint;        // Replacement color
bool   fBlend;       // Enable blending
bool   fInvert;      // Invert the effect

PS_OUTPUT ps_main(in PS_INPUT In)
{
    PS_OUTPUT Out;

    // Sample the background texture
    float4 BgColor = tex2D(bg, In.Texture);

    // Sample the object's texture to get the alpha channel
    float4 ObjTexColor = tex2D(Tex0, In.Texture);

    // Determine the tint color, using the object's alpha channel
    float4 RealTint = fAnimation ? ObjTexColor : float4(fTint.r, fTint.g, fTint.b, ObjTexColor.a);

    // Compute the difference between the background color and target color
    float3 TargetColor = float3(fTarget.r, fTarget.g, fTarget.b);
    float Difference = 1.0f - saturate(dot(abs(BgColor.rgb - TargetColor), (1.0f / 3.0f)));

    // Calculate blending factor based on tolerance
    float Blending = saturate((Difference - fTolerance) / (1.0f - fTolerance));

    // Create a mask for pixels that meet the tolerance criteria
    float Mask = step(fTolerance, Difference);

    // Invert the mask if fInvert is true
    if (fInvert)
    {
        Mask = 1.0f - Mask;
    }

    // Determine if blending or replacing is needed
    float BlendFactor = fBlend ? Blending * Mask : Mask;

    // Linearly interpolate between the background color and the tint color
    Out.Color.rgb = lerp(BgColor.rgb, RealTint.rgb, BlendFactor);
    Out.Color.a   = lerp(BgColor.a,   RealTint.a,   BlendFactor);

    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }
}
