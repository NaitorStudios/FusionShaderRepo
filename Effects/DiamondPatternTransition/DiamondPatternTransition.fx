//Based on this article:
//https://ddrkirby.com/articles/shader-based-transitions/shader-based-transitions.html

sampler2D texture0 : register(s0);
float size;
float progress;

float fPixelWidth, fPixelHeight;

float4 PS_Main(float2 UV : TEXCOORD0) : COLOR0
{
    float xFraction = frac(UV.x / (size * fPixelWidth));
    float yFraction = frac(UV.y / (size * fPixelHeight));
    
    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);
    
    if (xDistance + yDistance < progress)
    {
        discard;
    }
    
    return tex2D(texture0, UV);
}

technique Technique1
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 PS_Main();
    }
}
