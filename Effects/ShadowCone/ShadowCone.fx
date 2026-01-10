// Created by Adam Hawker (aka Sketchy / MuddyMole)
// Free for personal or commercial use

sampler2D img : register(s0);

int width;
int height;
int lightX;
int lightY;
int lightRadius;
int lightAmbient;
float coneAngle;
float coneRange;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{
	float ambient = lightAmbient / 255.0;
	float4 outRGB;
	float4 newRGB = tex2D(img, texCoord);
	if (newRGB.a >0) {
		outRGB = newRGB*ambient;
		outRGB.a = 1;
	} else {
	float rayDir;
	float2 rayPos;
	float2 rayMov;
	float2 lightPos = float2(lightX, lightY);
	float2 pixelPos = float2(texCoord.x * width, texCoord.y * height);
	float dist = distance(lightPos, pixelPos);	
	outRGB = float4(0,0,0,min(dist/lightRadius, 1-ambient));

	if (dist <= lightRadius) {
                rayPos = lightPos;
		rayDir = atan2(lightPos.y - pixelPos.y, lightPos.x - pixelPos.x);
        	rayMov = float2(cos(rayDir)*(dist/88), sin(rayDir)*(dist/88));
		float shortest_angle = ((((rayDir - coneAngle) % 6.28319f) + 9.42478f) % 6.28319f) - 3.14159f;
		//float shortest_angle = acos(dot(lightPos - pixelPos))
		if (abs(shortest_angle) <= coneRange) {
			for (int i=0; i<88; i++) {
				float4 getRGB = tex2D(img, float2(rayPos.x / width, rayPos.y / height));
				if (getRGB.a > 0) {
					outRGB = float4(0,0,0,1-ambient);
				}
			rayPos -= rayMov;
			}
		}
		else {
			outRGB = float4(0,0,0,1-ambient);
		}
	} else {
		outRGB = float4(0,0,0,1-ambient);
		}
	}
	return outRGB;
	}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }