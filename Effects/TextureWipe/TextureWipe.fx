
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
uniform sampler2D Tex0 : register(s0);
uniform sampler2D bkd : register(s1);
uniform sampler2D mask : register(s2);

uniform float p;
bool alphaWipe;
uniform float4 cWipe;
bool useHalo;
uniform float4 cHalo;
uniform float ramp;

float4 alpha_composite(float4 top, float4 bottom) {
    float alpha = top.a + bottom.a * (1.0 - top.a);
    return float4((top.rgb * top.a + bottom.rgb * (bottom.a * (1.0 - top.a))) / alpha, alpha);
}


float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
	float _ramp = max(ramp,0.0001);
	float4 Out;
    float4 before_pixel = tex2D(Tex0, In);
    float4 after_pixel = alphaWipe ? tex2D(bkd, In) : cWipe;
    float4 mask_pixel = tex2D(mask, In);
    float discriminator = mask_pixel.r + mask_pixel.g / 256.0 + mask_pixel.b / 65536.0;
    float scaled_t = p * (1.0 + _ramp * 2.0) - _ramp;
    if (useHalo) {
        // Compute the alpha of the halo such that it's 1.0 when the
        // discriminator matches exactly, and 0.0 just at the end of the ramp
        float alpha = clamp(1.0 - abs(scaled_t - discriminator) / _ramp, 0.0, 1.0);
		float new_a = 1-(1-alpha)*(1-before_pixel.a);
		alpha = (alpha*before_pixel.a*(alpha))/new_a;

        float4 halo = float4(cHalo.rgb, alpha);
        if (scaled_t < discriminator) {
            Out = alpha_composite(halo, before_pixel);
        }
        else {
            Out = alpha_composite(halo, after_pixel);
        }
    }
    else {
		float alpha = clamp((scaled_t - discriminator) / _ramp + 0.5, 0.0, 1.0);
        after_pixel.a *= alpha;
        Out = alpha_composite(after_pixel, before_pixel);
    }
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