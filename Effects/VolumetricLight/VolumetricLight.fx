// Volumetric Light - Clickteam Fusion 2.5
// -------------------------------------------------------
// Ported from the Shadertoy radial blur idea, adapted for Fusion.

texture Texture0;
sampler2D Sampler0 = sampler_state {
    Texture   = <Texture0>;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

// Controls
float fThreshold        = 0.80;
float fThresholdWidth   = 0.10;
float fAmount           = 0.50;  // "How far it projects" (blur radius / density)
float fPosX             = 0.50;
float fPosY             = 0.50;
float fDecay            = 0.97;  // Weight decay per step
float fStartWeight      = 0.10;  // Initial sample weight
float fBaseContribution = 0.25;  // Initial source contribution
float fSamples          = 24.0;  // Loop count (float slider; cast to int)
float fSpotlightScale   = 0.75;  // Spotlight multiplier scale
float fJitterAmount     = 1.0;   // Anti-banding jitter strength

// --- Notes -----------------------------------------------
//
// Full Scene Radial Blur
// ----------------------
//
// The radial blur loop starts at the pixel UV, then radiates towards (or away
// from) the chosen focal point, gathering samples with decreasing weighting.
// The result is a radial blur. The Shadertoy version jittered over time,
// but for Fusion we use a static hash-based jitter to avoid banding without
// relying on time.
//
// References (original inspiration):
// - Passion's "Blue Dream" and radial blur examples on Shadertoy
// - IQ's "Radial Blur"
// - mu6k's "Rays of Blinding Light"
//
// ---------------------------------------------------------------------------

// 2x1 hash. Used to jitter the samples (static, frame-independent).
float hash(float2 p) { return frac(sin(dot(p, float2(41.0, 289.0))) * 45758.5453); }

// Smoothstep helper (robust for small ranges)
float ss(float a, float b, float x) {
    float d = max(b - a, 1e-5);
    float t = saturate((x - a) / d);
    return t * t * (3.0 - 2.0 * t);
}

float4 PS_RadialBlur(float2 uv : TEXCOORD0) : COLOR0
{
    // Focal point in UV space (user-controlled).
    float2 center = float2(fPosX, fPosY);

    // Direction from center to current pixel — centered on zero for radial behavior.
    float2 tuv = (uv - center);

    // Density: how far we spread per step. "Amount" scales the overall radius.
    float density = fAmount;

    // dTuv is the per-step delta along the radial direction.
    float2 dTuv = (tuv * density) / max(fSamples, 1.0);

    // Base scene contribution.
    float4 col = tex2D(Sampler0, uv) * fBaseContribution;

    // Jittering to reduce banding. Static noise from UV — no time dependence.
    uv += dTuv * ((hash(uv + float2(0.123, 0.927)) * 2.0 - 1.0) * fJitterAmount);

    // Accumulation loop.
    float weight = fStartWeight;
    int   S      = (int)clamp(fSamples, 1.0, 2048.0); // safety clamp

    // Thresholding for "bright rays": smooth gate on sample luminance.
    float thA = fThreshold;
    float thB = fThreshold + fThresholdWidth;

    // The radial blur loop. Sample, move slightly towards center (or away if Amount < 0),
    // accumulate with decaying weights — matching the spirit of the original.
    [loop]
    for (int i = 0; i < S; ++i) {
        uv -= dTuv;
        float4 s = tex2D(Sampler0, uv);
        float  lum = length(s.rgb);
        float  gate = ss(thA, thB, lum);
        col += gate * s * weight;
        weight *= fDecay;
    }

    // Spotlight: multiply by a falloff centered on the focal point (from the original).
    float spotlight = saturate(1.0 - dot(tuv, tuv) * fSpotlightScale);
    col *= spotlight;

    // Smoothstep & loose gamma correction from the original.
    col = sqrt(saturate(col));

    return col;
}

technique T0
{
    pass P0
    {
        PixelShader = compile ps_2_b PS_RadialBlur();
    }
}
