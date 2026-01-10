sampler2D img;
float distortion_amount;
float time;
float fPixelWidth, fPixelHeight;

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

float4 ps_main(in float2 In: TEXCOORD0) : COLOR0
{
    // Scale down the time to slow the effect
    float scaled_time = time * 0.1;

    // Generate distortion offsets with improved noise
    float2 offset = float2(noise(In + scaled_time), noise(In + scaled_time + 1.0)) * 2.0 - 1.0;
    offset *= distortion_amount;

    // Sample the texture with the distorted coordinates
    float4 color = tex2D(img, In + offset * float2(fPixelWidth, fPixelHeight));

    return color;
}

technique tech_main
{
    pass P0
    {
        PixelShader = compile ps_2_0 ps_main();
    }
}
