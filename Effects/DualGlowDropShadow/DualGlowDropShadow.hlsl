Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
    // Shadow variables
    float sX;
    float sY;
    float sAngle;
    float4 sColor;
    float sAlpha;

    // Glow variables
    float oRadius;
    float oExponent;
    float4 oColor;
    float oAlpha;
    float iRadius;
    float iExponent;
    float4 iColor;
};

cbuffer PS_PIXELSIZE : register(b1)
{
    float fPixelWidth;
    float fPixelHeight;
};

static const float2 offsets[12] = {
   -0.326212, -0.305805,
   -0.840144,  0.073580,
   -0.695914,  0.557137,
   -0.203345,  0.720716,
    0.962340, -0.094983,
    0.473434, -0.380026,
    0.519456,  0.867022,
    0.185461, -0.793124,
    0.507431,  0.164425,
    0.896420,  0.512458,
   -0.321940, -0.832615,
   -0.791559, -0.497705,
};

// Function to calculate shadow pixel coordinates
float2 getshadowxy(float2 xy)
{
    float2 pixel;
    if(sAngle != 0)
    {
        float theta = radians(sAngle);
        float2 pnt = float2(cos(theta) * sX - sin(theta) * sY, sin(theta) * sX + cos(theta) * sY);
        pixel = xy - float2(pnt.x * fPixelWidth, pnt.y * fPixelHeight);
    }
    else
    {
        pixel = xy - float2(sX * fPixelWidth, sY * fPixelHeight);
    }
    return pixel;
}

// Non-Premultiplied Alpha Shader
float4 ps_main(PS_INPUT In) : SV_TARGET
{
    // ----- Base Color -----
    float4 baseColor = Texture0.Sample(TextureSampler0, In.texCoord) * In.Tint;

    // ----- Shadow Effect -----
    float4 shadow = float4(0, 0, 0, 0);
    float2 shadowPixel = getshadowxy(In.texCoord);
    if(shadowPixel.x >= 0 && shadowPixel.x <= 1 && shadowPixel.y >= 0 && shadowPixel.y <= 1)
    {
        // Sample the alpha from the shadow position
        float shadowAlpha = Texture0.Sample(TextureSampler0, shadowPixel).a * In.Tint.a * sAlpha;

        // Set shadow color with modified alpha
        shadow = sColor;
        shadow.a = shadowAlpha;
    }
	
	int i;

    // ----- Glow Effect -----
    // Inner Glow Accumulation
    float innerGlowAcc = baseColor.a;
    for(i = 0; i < 12; i++)
    {
        float2 sampleCoord = In.texCoord + iRadius * float2(fPixelWidth, fPixelHeight) * offsets[i];
        innerGlowAcc += Texture0.Sample(TextureSampler0, sampleCoord).a * In.Tint.a;
    }
    innerGlowAcc /= 13.0;

    // Inner Glow Color
    float3 innerGlow = lerp(iColor.rgb, baseColor.rgb, pow(abs(innerGlowAcc), iExponent));

    // Outer Glow Accumulation
    float outerGlowAcc = baseColor.a;
    for(i = 0; i < 12; i++)
    {
        float2 sampleCoord = In.texCoord + oRadius * float2(fPixelWidth, fPixelHeight) * offsets[i];
        outerGlowAcc += Texture0.Sample(TextureSampler0, sampleCoord).a * In.Tint.a;
    }
    outerGlowAcc /= 13.0;

    // Outer Glow Color
    float3 outerGlow = lerp(oColor.rgb, innerGlow, pow(abs(outerGlowAcc), oExponent));

    // Final Glow Color and Alpha
    float4 glowColor;
    glowColor.rgb = outerGlow;
    glowColor.a = max((1.0 - pow(abs(1.0 - outerGlowAcc), oExponent)) * oAlpha, baseColor.a);

    // ----- Combine Shadow and Glow -----
    // Standard Over Blending: ObjectWithGlow over Shadow
    float new_a = glowColor.a + shadow.a * (1.0 - glowColor.a);
    float3 final_rgb = (glowColor.rgb * glowColor.a) + (shadow.rgb * shadow.a * (1.0 - glowColor.a));
    final_rgb /= new_a;

    float4 finalColor = float4(final_rgb, new_a);

    return finalColor;
}

// Premultiplied Alpha Shader
float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
    // ----- Base Color (Premultiplied) -----
    float4 baseColor = Texture0.Sample(TextureSampler0, In.texCoord) * In.Tint;

    // ----- Shadow Effect -----
    float4 shadow = float4(0, 0, 0, 0);
    float2 shadowPixel = getshadowxy(In.texCoord);
    if(shadowPixel.x >= 0 && shadowPixel.x <= 1 && shadowPixel.y >= 0 && shadowPixel.y <= 1)
    {
        // Sample the alpha from the shadow position
        float shadowAlpha = Texture0.Sample(TextureSampler0, shadowPixel).a * In.Tint.a * sAlpha;

        // Set shadow color with modified alpha
        shadow = sColor;
        shadow.a = shadowAlpha;

        // Since baseColor is premultiplied, multiply shadow.rgb by shadow.a
        shadow.rgb *= shadow.a;
    }
	
	int i;

    // ----- Glow Effect -----
    // Inner Glow Accumulation
    float innerGlowAcc = baseColor.a;
    for(i = 0; i < 12; i++)
    {
        float2 sampleCoord = In.texCoord + iRadius * float2(fPixelWidth, fPixelHeight) * offsets[i];
        innerGlowAcc += Texture0.Sample(TextureSampler0, sampleCoord).a * In.Tint.a;
    }
    innerGlowAcc /= 13.0;

    // Inner Glow Color (Unpremultiplied for accurate blending)
    float3 innerGlow = lerp(iColor.rgb, baseColor.rgb / baseColor.a, pow(abs(innerGlowAcc), iExponent));

    // Outer Glow Accumulation
    float outerGlowAcc = baseColor.a;
    for(i = 0; i < 12; i++)
    {
        float2 sampleCoord = In.texCoord + oRadius * float2(fPixelWidth, fPixelHeight) * offsets[i];
        outerGlowAcc += Texture0.Sample(TextureSampler0, sampleCoord).a * In.Tint.a;
    }
    outerGlowAcc /= 13.0;

    // Outer Glow Color (Unpremultiplied for accurate blending)
    float3 outerGlow = lerp(oColor.rgb, innerGlow, pow(abs(outerGlowAcc), oExponent));

    // Final Glow Color and Alpha (Premultiplied)
    float4 glowColor;
    glowColor.rgb = outerGlow * max((1.0 - pow(abs(1.0 - outerGlowAcc), oExponent)) * oAlpha, baseColor.a);
    glowColor.a = max((1.0 - pow(abs(1.0 - outerGlowAcc), oExponent)) * oAlpha, baseColor.a);

    // ----- Combine Shadow and Glow -----
    // Standard Over Blending: ObjectWithGlow over Shadow
    float4 objectWithGlow = glowColor;

    // Since both are premultiplied, simple addition works
    float4 finalColor;
    finalColor.rgb = objectWithGlow.rgb + shadow.rgb * (1.0 - objectWithGlow.a);
    finalColor.a = objectWithGlow.a + shadow.a * (1.0 - objectWithGlow.a);

    return finalColor;
}
