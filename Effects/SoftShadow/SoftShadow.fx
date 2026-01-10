// Soft Shadow
// v1.0
// By asker

sampler2D img : register(s0);
float4 shadowColor;
float opacity, offsetX, offsetY, sampleDistance;

float fPixelWidth;
float fPixelHeight;

static int SHADOW_ITERATIONS = 24;
static float ANGLE_INCREASE = 6.28318530717 / SHADOW_ITERATIONS;


float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR0
{
    float2 pixelCorrection = float2(fPixelWidth, fPixelHeight);
    float4 p = tex2D(img, texCoord);
    float2 pos = texCoord - float2(offsetX, offsetY) * pixelCorrection;
    float shadowIntensity = 0.0;
    for(int i = 0; i < SHADOW_ITERATIONS; i++) {
        shadowIntensity += tex2D(img, pos + float2(cos(i * ANGLE_INCREASE), sin(i * ANGLE_INCREASE)) * sampleDistance * pixelCorrection).a;
    }
    float sa = shadowIntensity * opacity / SHADOW_ITERATIONS;
    float a0 = p.a + sa * (1.0 - p.a);
    float4 color = float4((p.rgb * p.a + shadowColor.rgb * sa * (1.0 - p.a)) / a0, a0);
    return color;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 ps_main();
    }
}
