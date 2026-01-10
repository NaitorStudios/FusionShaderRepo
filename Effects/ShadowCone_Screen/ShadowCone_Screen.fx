// Created by Adam Hawker (aka Sketchy / MuddyMole)
// Free for personal or commercial use

sampler2D img : register(s0);
sampler2D bg : register(s1);

int width;
int height;
int lightX;
int lightY;
int lightRadius;
float lightStrength;
float3 lightColour;
float coneAngle;
float coneRange;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0{
	float b = lightColour.b;
	lightColour.b = lightColour.r;
	lightColour.r = b;
	float4 outRGB = tex2D(img, texCoord);
	if (outRGB.a > 0) {
		outRGB = float4(0, 0, 0, 1);
	}
	else {
		float2 lightPos = float2(lightX, lightY);
		float2 pixelPos = float2(texCoord.x * width, texCoord.y * height);
		float dist = distance(lightPos, pixelPos);
		outRGB.rgb = float3(lightColour * (1.0f - min(dist / lightRadius, 1)) * lightStrength);

		if (dist <= lightRadius) {
			float2 rayPos = lightPos;
			float rayDir = atan2(lightPos.y - pixelPos.y, lightPos.x - pixelPos.x);
			float2 rayMov = float2(cos(rayDir) * (dist / 88), sin(rayDir) * (dist / 88));
			float shortest_angle = ((((rayDir - coneAngle) % 6.28319f) + 9.42478f) % 6.28319f) - 3.14159f;
			if (abs(shortest_angle) <= coneRange) {
				for (int i = 0; i < 88; i++) {
					float4 getRGB = tex2D(img, float2(rayPos.x / width, rayPos.y / height));
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
	float4 bgClr = tex2D(bg, texCoord);
	outRGB.a = 1.0f;
	outRGB.r = 1.0f - ((1.0f - bgClr.r) * (1.0f - outRGB.r));
	outRGB.g = 1.0f - ((1.0f - bgClr.g) * (1.0f - outRGB.g));
	outRGB.b = 1.0f - ((1.0f - bgClr.b) * (1.0f - outRGB.b));
	return outRGB;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }