//Based on this article:
//https://ddrkirby.com/articles/shader-based-transitions/shader-based-transitions.html

struct PS_INPUT
{
	float4 Tint : COLOR0;
	float2 TexCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
	float4 Color : SV_TARGET;
};

Texture2D texture0 : register(t0);
SamplerState Sampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float size;
	float progress;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float xFraction = frac(In.TexCoord.x / (size * fPixelWidth));
    float yFraction = frac(In.TexCoord.y / (size * fPixelHeight));
    
    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);
    
    if (xDistance + yDistance < progress)
    {
        discard;
    }
    
    return texture0.Sample(Sampler0, In.TexCoord);
}

