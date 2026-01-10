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

Texture2D bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	int width;
	int height;
	int lightX;
	int lightY;
	int lightRadius;
	float lightStrength;
	float3 lightColour;
	float coneAngle;
	float coneRange;
};

float4 Demultiply(float4 _color)
{
    float4 color = _color;
    if (color.a != 0)
        color.xyz /= color.a;
    return color;
}

float4 effect(PS_INPUT In, bool PM) : SV_TARGET
{
	float3 lightColourAdjusted = float3(lightColour.b, lightColour.g, lightColour.r);
	float4 outRGB = Demultiply(img.Sample(imgSampler, In.texCoord) * In.Tint);
	if (outRGB.a > 0) {
		outRGB = float4(0, 0, 0, 1);
	}
	else {
		float2 lightPos = float2(lightX, lightY);
		float2 pixelPos = float2(In.texCoord.x * width, In.texCoord.y * height);
		float dist = distance(lightPos, pixelPos);
		outRGB.rgb = float3(lightColourAdjusted * (1.0f - min(dist / lightRadius, 1)) * lightStrength);

		if (dist <= lightRadius) {
			float2 rayPos = lightPos;
			float rayDir = atan2(lightPos.y - pixelPos.y, lightPos.x - pixelPos.x);
			float2 rayMov = float2(cos(rayDir) * (dist / 88), sin(rayDir) * (dist / 88));
			float shortest_angle = ((((rayDir - coneAngle) % 6.28319f) + 9.42478f) % 6.28319f) - 3.14159f;
			if (abs(shortest_angle) <= coneRange) {
				[unroll] for (int i = 0; i < 88; i++) {
					float4 getRGB = img.Sample(imgSampler, float2(rayPos.x / width, rayPos.y / height));
					if (getRGB.a > 0) {
						outRGB = float4(0, 0, 0, 1);
					}
					rayPos -= rayMov;
				}
			}
			else {
				outRGB = float4(0, 0, 0, 1);
			}
		}
		else {
			outRGB = float4(0, 0, 0, 1);
		}
	}
	float4 bgClr = bg.Sample(bgSampler, In.texCoord);
	outRGB.a = 1.0f;
	outRGB.r = 1.0f - ((1.0f - bgClr.r) * (1.0f - outRGB.r));
	outRGB.g = 1.0f - ((1.0f - bgClr.g) * (1.0f - outRGB.g));
	outRGB.b = 1.0f - ((1.0f - bgClr.b) * (1.0f - outRGB.b));
	
    if (PM)
        outRGB.rgb *= outRGB.a;

    return outRGB;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    return effect(In, false);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    return effect(In, true);
}