
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float tw, th = 32.0;
	float xOffset, yOffset;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float4 Color;
    float4 output = 1;

    //Get Texture scaling ratios.
    float ratioX=  (1 / fPixelWidth) / tw;
    float ratioY=  (1 / fPixelHeight) / th;

    output = img.Sample( imgSampler, float2(  In.texCoord.x  * ratioX + xOffset ,  In.texCoord.y * ratioY + yOffset )) * In.Tint;
	
    return output ;
}
