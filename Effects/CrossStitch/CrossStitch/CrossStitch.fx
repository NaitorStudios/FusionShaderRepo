// Cross-Stich
// v1.0
// By asker

sampler2D img : register(s0);
int stitchWidth, stitchHeight;
sampler2D patternImg : register(s1);
int patternWidth, patternHeight;

float fPixelWidth;
float fPixelHeight;

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR0
{
    //Calculate the size of one stitch in uv space
    float2 texelStitchSize = float2(stitchWidth * fPixelWidth, stitchHeight * fPixelHeight);
    //Calculate the size of each stitch in uv space
    float2 gridPos = texCoord / texelStitchSize;
    //Fetch the center of the square (by adding one half grid) and convert to uv position
    float4 color = tex2D(img, (floor(gridPos) + 0.5) * texelStitchSize);

    float4 patternColor = tex2D(patternImg, gridPos / float2(patternWidth, patternHeight));
    // Apply shadow effect
    return color * patternColor;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_a ps_main();
    }
}
