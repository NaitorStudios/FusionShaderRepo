// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

Texture2D<float4> Overlay : register(t1);
sampler OverlaySampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float Intensity;
	int tw, th;
	float xOffset, yOffset;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth, fPixelHeight;
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
    float4 output = 0;

    //Get Texture scaling ratios.
	float2 Offset = float2(xOffset,yOffset);
    float2 ratio  = float2((1 / fPixelWidth ) / tw,
						   (1 / fPixelHeight) / th);

    Color = Demultiply(Tex0.Sample( Tex0Sampler, In.texCoord));
    output = Demultiply(Overlay.Sample( OverlaySampler, In.texCoord * ratio + Offset ));
	
	// Alpha Overlay
	float new_a = 1-(1-output.a)*(1-Color.a) ;
	output.rgb = (output.rgb*output.a+Color.rgb*Color.a*(1-output.a))/new_a ;
    output.rgb = lerp( Color.rgb, output.rgb, Intensity);
    output.a = Color.a;
	output *= In.Tint;
	
    return output;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    float4 Color;
    float4 output = 0;

    //Get Texture scaling ratios.
	float2 Offset = float2(xOffset,yOffset);
    float2 ratio  = float2((1 / fPixelWidth ) / tw,
						   (1 / fPixelHeight) / th);

    Color = Demultiply(Tex0.Sample( Tex0Sampler, In.texCoord));
    output = Demultiply(Overlay.Sample( OverlaySampler, In.texCoord * ratio + Offset ));
	
	// Alpha Overlay
	float new_a = 1-(1-output.a)*(1-Color.a) ;
	output.rgb = (output.rgb*output.a+Color.rgb*Color.a*(1-output.a))/new_a ;
    output.rgb = lerp( Color.rgb, output.rgb, Intensity);
    output.a = Color.a;
	output.rgb *= output.a;
	output *= In.Tint;
	
    return output;
}

