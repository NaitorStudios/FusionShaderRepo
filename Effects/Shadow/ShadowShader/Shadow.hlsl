// Created by Adam Hawker (aka Sketchy / MuddyMole)
// Free for personal or commercial use

struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

Texture2D img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
    int width;
    int height;
    int lightX;
    int lightY;
    int lightRadius;
    int lightAmbient;
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
    float ambient = lightAmbient / 255.0;
    float4 outRGB;
    float4 newRGB = Demultiply(img.Sample(imgSampler, In.texCoord) * In.Tint);
    if (newRGB.a > 0)
    {
        outRGB = newRGB * ambient;
        outRGB.a = 1;
    }
    else
    {
        float rayDir;
        float2 rayPos;
        float2 rayMov;
        float2 lightPos = float2(lightX, lightY);
        float2 pixelPos = float2(In.texCoord.x * width, In.texCoord.y * height);
        float dist = distance(lightPos, pixelPos);
        outRGB = float4(0, 0, 0, min(dist / lightRadius, 1 - ambient));

        if (dist <= lightRadius)
        {
            rayPos = lightPos;
            rayDir = atan2(lightPos.y - pixelPos.y, lightPos.x - pixelPos.x);
            rayMov = float2(cos(rayDir) * (dist / 90), sin(rayDir) * (dist / 90));
            [unroll] for (int i = 0; i < 90; i++)
            {
                float4 getRGB = img.Sample(imgSampler, float2(rayPos.x / width, rayPos.y / height));
                if (getRGB.a > 0)
                {
                    outRGB = float4(0, 0, 0, 1 - ambient);
                }
                rayPos -= rayMov;
            }
        }
        else
        {
            outRGB = float4(0, 0, 0, 1 - ambient);
        }
    }
    if (PM)
		outRGB.rgb *= outRGB.a;
		
	return outRGB;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}