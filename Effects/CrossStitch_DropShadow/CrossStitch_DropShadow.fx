// Cross-Stich With Drop Shadow
// v1.0
// By asker

sampler2D img : register(s0);
int stitchWidth, stitchHeight;
sampler2D patternImg : register(s1);
int patternWidth, patternHeight;
float shadowDistance;
float shadowOpacity;

float fPixelWidth;
float fPixelHeight;

static int SHADOW_ITERATIONS = 4;

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR0
{
    float4 outColor;
    float shadow = 0.0;
    //Calculate the size of one stitch in uv space
    float2 texelStitchSize = float2(stitchWidth * fPixelWidth, stitchHeight * fPixelHeight);
    for (int i = 0; i < SHADOW_ITERATIONS; i++) {
        float2 offset = float2(i * fPixelWidth, i * fPixelHeight) * -shadowDistance / SHADOW_ITERATIONS;
        //Calculate the size of each stitch in uv space
        float2 gridPos = (texCoord + offset) / texelStitchSize;
        //Fetch the center of the square (by adding one half grid) and convert to uv position
        float4 color = tex2D(img, (floor(gridPos) + 0.5) * texelStitchSize);

        float4 patternColor = tex2D(patternImg, gridPos / float2(patternWidth, patternHeight));
        if(i == 0)
            outColor = color * patternColor;
        shadow += patternColor.a * color.a;
    }
    // Apply shadow effect
    return lerp(float4(0, 0, 0, shadow * shadowOpacity / SHADOW_ITERATIONS), outColor, outColor.a);
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_a ps_main();
    }
}
