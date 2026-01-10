// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES:register(b0)
{
	float4 color;
	float intensity;
	float seed;
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

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    float4 col = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint);

    
    float r = col.r;
    float g = col.g;
    float b = col.b;
    float a = col.a;

    
    float groupR = floor(r * (1.0/fPixelWidth));
    float groupG = floor(g * (1.0/fPixelHeight));
    float groupB = floor(b * (1.0/fPixelWidth));
    float2 groupUV = float2(groupR, groupG) / float2(fPixelWidth, fPixelHeight);

    
    float rand = frac(sin(dot(float2(groupUV.x, groupUV.y + seed), float2(12.9898, 78.233))) * 43758.5453);

    
    if (rand < intensity)
    {
        // Generate a new random color for the pixel
        float3 randColor = float3(
            frac(sin(rand * 1.234 + groupUV.x + seed) * 567.123),
            frac(sin(rand * 5.678 + groupUV.y + seed) * 789.456),
            frac(sin(rand * 9.012 + seed) * 345.678)
        );
        col.rgb = lerp(col.rgb, randColor * color.rgb, intensity);
        col.a = a;  
    }
    else
    {
        col.rgb *= color.rgb;
        col.a = a;
    }

    clip(col.a - 0.5);
	if (PM)
		col.rgb *= col.a;
	
  return col;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}