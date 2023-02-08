
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
Texture2D<float4> Overlay : register(t1);
sampler OverlaySampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float Intensity = 1.0;
	int tw, th = 32;
	float xOffset, yOffset;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
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
    float4 Color;
    float4 output = 1;

    //Get Texture scaling ratios.
    float ratioX=  (1 / fPixelWidth) / tw;
    float ratioY=  (1 / fPixelHeight) / th;

    Color = Demultiply(img.Sample(imgSampler,In.texCoord) * In.Tint);

    output = Demultiply(Overlay.Sample( OverlaySampler, float2(  In.texCoord.x  * ratioX + xOffset ,  In.texCoord.y * ratioY + yOffset )));
	// Alpha Overlay
	output.a = lerp(0.0, Color.a * output.a, Intensity);
	output.rgb = output.rgb - (Intensity-1.0);
	
    return output ;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    float4 Color;
    float4 output = 1;

    //Get Texture scaling ratios.
    float ratioX=  (1 / fPixelWidth) / tw;
    float ratioY=  (1 / fPixelHeight) / th;

    Color = Demultiply(img.Sample(imgSampler,In.texCoord) * In.Tint);

    output = Demultiply(Overlay.Sample( OverlaySampler, float2(  In.texCoord.x  * ratioX + xOffset ,  In.texCoord.y * ratioY + yOffset )));
	// Alpha Overlay
	output.a = lerp(0.0, Color.a * output.a, Intensity);
	output.rgb = output.rgb - (Intensity-1.0);
	
	output.rgb *= output.a;
    return output ;
}
