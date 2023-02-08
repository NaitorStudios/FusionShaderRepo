Texture2D<float4> tImg : register(t0);
sampler sImg : register(s0);

Texture2D<float4> tPal : register(t1);
sampler sPal : register(s1);

cbuffer PS_VARIABLES : register(b0) {
  int iFlipX, iFlipY, iRotate;
  float fOpacity;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

static const int ptn[64] = {
   0, 32,  8, 40,  2, 34, 10, 42,
  48, 16, 56, 24, 50, 18, 58, 26,
  12, 44,  4, 36, 14, 46,  6, 38,
  60, 28, 52, 20, 62, 30, 54, 22,
   3, 35, 11, 43,  1, 33,  9, 41,
  51, 19, 59, 27, 49, 17, 57, 25,
  15, 47,  7, 39, 13, 45,  5, 37, 
  63, 31, 55, 23, 61, 29, 53, 21
};

//--------------------------------------------------------------------------------------------

float4 ps_main( in PS_INPUT In ) : SV_TARGET {

  // Mirror
  if (iFlipX) { In.texCoord.x = 1.0 - In.texCoord.x; }
  
  // Flip
  if (iFlipY) { In.texCoord.y = 1.0 - In.texCoord.y; }
  
  // Rotate 90 degrees
  if (iRotate) { In.texCoord.xy = float2(In.texCoord.y, 1.0 - In.texCoord.x); }
  
  // Sample pixel from image
  float4 imgPixel = tImg.Sample(sImg, In.texCoord);

  // Get palette index from red component
  uint index = 255.0 * imgPixel.r;

  // Sample pixel from palette
  float4 palPixel = tPal.Sample(sPal, float2((index % 16) * 0.0625, (index / 16) * 0.0625)) * In.Tint;
  
  // Get pixel coordinates relative to an 8x8 pixel pattern
  int xIn = (In.texCoord.x * (1.0 / fPixelWidth)) % 8;
  int yIn = (In.texCoord.y * (1.0 / fPixelHeight)) % 8;

  // Get alpha value of pixel on a scale of 0-64
  int alpha = round(palPixel.a * fOpacity * 64.0);

  // Get pattern index
  int ptnPixel = yIn * 8 + xIn;
  
  // Determine if the pixel should be 100% transparent or 100% opaque
  palPixel.a = ptn[ptnPixel] < alpha ? 1 : 0;
  palPixel.rgb *= palPixel.a;
  return palPixel;
}