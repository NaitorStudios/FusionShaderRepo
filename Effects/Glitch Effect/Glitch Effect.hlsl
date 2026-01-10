struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
    float distortion_amount;
    float time;
};

cbuffer PS_PIXELSIZE : register(b1)
{
    float fPixelWidth;
    float fPixelHeight;
};

// Function to generate smoother Perlin noise
float noise(float2 p)
{
    float2 i = floor(p);
    float2 f = frac(p);
    
    // Interpolation
    f = f * f * (3.0 - 2.0 * f);

    float2 uv = (i + float2(37.0, 17.0) * i.yx + f) * (1.0 / 289.0);
    float2 rg = frac(sin(uv * float2(12.9898, 78.233)) * 43758.5453);
    
    return lerp(rg.x, rg.y, f.y);
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    // Scale down the time to slow the effect
    float scaled_time = time * 0.1;

    // Generate distortion offsets with improved noise
    float2 offset = float2(noise(In.texCoord + scaled_time), noise(In.texCoord + scaled_time + 1.0)) * 2.0 - 1.0;
    offset *= distortion_amount;

    // Sample the texture with the distorted coordinates
    float4 color = img.Sample(imgSampler, In.texCoord + offset * float2(fPixelWidth, fPixelHeight));

    return color * In.Tint;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    // Scale down the time to slow the effect
    float scaled_time = time * 0.1;

    // Generate distortion offsets with improved noise
    float2 offset = float2(noise(In.texCoord + scaled_time), noise(In.texCoord + scaled_time + 1.0)) * 2.0 - 1.0;
    offset *= distortion_amount;

    // Sample the texture with the distorted coordinates
    float4 color = img.Sample(imgSampler, In.texCoord + offset * float2(fPixelWidth, fPixelHeight));

    if (color.a != 0)
        color.rgb /= color.a;

    return color * In.Tint;
}
