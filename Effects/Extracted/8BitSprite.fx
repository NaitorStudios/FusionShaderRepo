sampler2D img;
sampler2D pal : register(s1);
int iFlipX, iFlipY, iRotate;
float fOpacity, fPixelWidth, fPixelHeight;

int4x4 ptn0 = {    0, 48, 12, 60,
		  32, 16, 44, 28,
		   8, 56,  4, 52,
		  40, 24, 36, 20 };

int4x4 ptn1 = {    3, 51, 15, 63,
		  35, 19, 47, 31,
		  11, 59,  7, 55,
		  43, 27, 39, 23 };

int4x4 ptn2 = {    2, 50, 14, 62,
		  34, 18, 46, 30,
		  10, 58,  6, 54,
		  42, 26, 38, 22 };

int4x4 ptn3 = {    1, 49, 13, 61,
		  33, 17, 45, 29,
		   9, 57,  5, 53,
		  41, 25, 37, 21 };

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
  if (iFlipX) { In.x = 1.0 - In.x; }
  if (iFlipY) { In.y = 1.0 - In.y; }
  if (iRotate) { In.xy = float2(In.y, 1.0 - In.x); }
  float4 imgPixel = tex2D(img, In);
  int index = 255.0 * imgPixel.r;
  float4 palPixel = tex2D(pal, float2((index % 16) * 0.0625, (index / 16) * 0.0625));
  int xIn = (In.x * (1.0 / fPixelWidth)) % 8;
  int yIn = (In.y * (1.0 / fPixelHeight)) % 8;
  int alpha = round(palPixel.a * fOpacity * 64.0);
  int pattern = floor( xIn / 4.0 ) + (floor( yIn / 4.0 ) * 2);
  palPixel.a = 0;
  if (pattern == 0 && ptn0[xIn][yIn] < alpha) {palPixel.a = 1;}
  else if (pattern == 1 && ptn1[xIn-4][yIn] < alpha) {palPixel.a = 1;}
  else if (pattern == 2 && ptn2[xIn][yIn-4] < alpha) {palPixel.a = 1;}
  else if (pattern == 3 && ptn3[xIn-4][yIn-4] < alpha) {palPixel.a = 1;}
  return palPixel;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_a ps_main(); }  }