// Cross-Stich
// v1.0
// By asker

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);
Texture2D<float4> patternImg : register(t1);
sampler patternSampler : register(s1);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
	int stitchWidth;
    int stitchHeight;
	int patternWidth;
    int patternHeight;
    float shadowDistance;
    float shadowOpacity;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 ps_main(PS_INPUT In) : SV_TARGET
{
    //Calculate the size of one stitch in uv space
    float2 texelStitchSize = float2(stitchWidth * fPixelWidth, stitchHeight * fPixelHeight);
    //Calculate the size of each stitch in uv space
    float2 gridPos = texCoord / texelStitchSize;
    //Fetch the center of the square (by adding one half grid) and convert to uv position
    float4 color = img.Sample(imgSampler, (floor(gridPos) + 0.5) * texelStitchSize);

    float4 patternColor = patternImg.Sample(patternSampler, gridPos / float2(patternWidth, patternHeight));
    return color * patternColor * In.Tint;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
    //Calculate the size of one stitch in uv space
    float2 texelStitchSize = float2(stitchWidth * fPixelWidth, stitchHeight * fPixelHeight);
    //Calculate the size of each stitch in uv space
    float2 gridPos = texCoord / texelStitchSize;
    //Fetch the center of the square (by adding one half grid) and convert to uv position
    float4 color = Demultiply(img.Sample(imgSampler, (floor(gridPos) + 0.5) * texelStitchSize));

    float4 patternColor = Demultiply(patternImg.Sample(patternSampler, gridPos / float2(patternWidth, patternHeight)));
    float4 outColor = color * patternColor;
    //Premultiply alpha
    outColor.rgb *= outColor.a;
    return outColor * In.Tint;
}