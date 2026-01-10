// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
uniform sampler2D before : register(s0);
uniform sampler2D after : register(s1);
uniform sampler2D mask : register(s2);

uniform float p;
uniform float ramp;

float4 alpha_composite(float4 top, float4 bottom) {
    float alpha = top.a + bottom.a * (1.0 - top.a);
    return float4((top.rgb * top.a + bottom.rgb * (bottom.a * (1.0 - top.a))) / alpha, alpha);
}

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
    float4 before_pixel = tex2D(before, In);
    float4 after_pixel = tex2D(after, In);
    float4 mask_pixel = tex2D(mask, In);

    float discriminator = mask_pixel.r + mask_pixel.g / 256.0 + mask_pixel.b / 65536.0;
    float scaled_p = p * (1.0 + ramp * 2.0) - ramp;
    float alpha = clamp((scaled_p - discriminator) / ramp + 0.5, 0.0, 1.0);
    
    after_pixel.a *= alpha;
    float4 Out = alpha_composite(after_pixel, before_pixel);

    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}
