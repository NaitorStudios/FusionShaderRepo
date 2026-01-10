
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

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	int h;
	float dark;
	float bright;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord));

	float red = float(int((Out.Color.r *255) / h) * h) / 255;
	float green = float(int((Out.Color.g *255) / h) * h) / 255;
	float blue = float(int((Out.Color.b *255) / h) * h) / 255;

	if (red > bright)
	{
		red = 1;
	}
	else if (red < dark)
	{
		red = 0;
	}
	
	if (green > bright)
	{
		green = 1;
	}
	else if (green < dark)
	{
		green = 0;
	}
	
	if (blue > bright)
	{
		blue = 1;
	}
	else if (blue < dark)
	{
		blue = 0;
	}
	
	Out.Color.r = red;
	Out.Color.g = green;
	Out.Color.b = blue;
	Out.Color *= In.Tint;
	
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord));

	float red = float(int((Out.Color.r *255) / h) * h) / 255;
	float green = float(int((Out.Color.g *255) / h) * h) / 255;
	float blue = float(int((Out.Color.b *255) / h) * h) / 255;

	if (red > bright)
	{
		red = 1;
	}
	else if (red < dark)
	{
		red = 0;
	}
	
	if (green > bright)
	{
		green = 1;
	}
	else if (green < dark)
	{
		green = 0;
	}
	
	if (blue > bright)
	{
		blue = 1;
	}
	else if (blue < dark)
	{
		blue = 0;
	}
	
	Out.Color.r = red;
	Out.Color.g = green;
	Out.Color.b = blue;
	Out.Color *= In.Tint;
	Out.Color.rgb *= Out.Color.a;
	
    return Out;
}

