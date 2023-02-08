
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};


Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
float multiplier;
};

cbuffer PS_PIXELSIZE : register(b1)
{
    float fPixelWidth;
    float fPixelHeight;
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

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}


float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 pixel = Demultiply(img.Sample(imgSampler,In.texCoord) * In.Tint);
	
	// Get pixel coordinates relative to an 8x8 pixel pattern
	int xIn = (In.texCoord.x * (1.0 / fPixelWidth)) % 8;
	int yIn = (In.texCoord.y * (1.0 / fPixelHeight)) % 8;
	
	// Get alpha value of pixel on a scale of 0-64
	int alpha = round(pixel.a * multiplier * 64.0);
	
	// Get pattern index
	int ptnPixel = yIn * 8 + xIn;
	
	// Determine if the pixel should be 100% transparent or 100% opaque
	pixel.a = ptn[ptnPixel] < alpha ? 1 : 0;
	pixel.rgb *= pixel.a;
	return pixel;
}

