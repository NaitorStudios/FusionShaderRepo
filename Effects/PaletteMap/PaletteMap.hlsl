struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> palette : register(t1);
sampler paletteSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	int Cols;
	int Rows;
};

/*
 * Thanks to : http://mouaif.wordpress.com/2009/01/08/photoshop-math-with-hlsl-shaders/
 */
float3 rgb2hsl(float3 color)
{
	float3 hsl; // init to 0 to avoid warnings ? (and reverse if + remove first part)
	
	float fmin = min(min(color.r, color.g), color.b);    //Min. value of RGB
	float fmax = max(max(color.r, color.g), color.b);    //Max. value of RGB
	float delta = fmax - fmin;             //Delta RGB value

	hsl.z = (fmax + fmin) / 2.0; // Luminance

	if (delta == 0.0)		//This is a gray, no chroma...
	{
		hsl.x = 0.0;	// Hue
		hsl.y = 0.0;	// Saturation
	}
	else                                    //Chromatic data...
	{
		if (hsl.z < 0.5)
			hsl.y = delta / (fmax + fmin); // Saturation
		else
			hsl.y = delta / (2.0 - fmax - fmin); // Saturation
		
		float deltaR = (((fmax - color.r) / 6.0) + (delta / 2.0)) / delta;
		float deltaG = (((fmax - color.g) / 6.0) + (delta / 2.0)) / delta;
		float deltaB = (((fmax - color.b) / 6.0) + (delta / 2.0)) / delta;

		if (color.r == fmax )
			hsl.x = deltaB - deltaG; // Hue
		else if (color.g == fmax)
			hsl.x = (1.0 / 3.0) + deltaR - deltaB; // Hue
		else if (color.b == fmax)
			hsl.x = (2.0 / 3.0) + deltaG - deltaR; // Hue

		if (hsl.x < 0.0)
			hsl.x += 1.0; // Hue
		else if (hsl.x > 1.0)
			hsl.x -= 1.0; // Hue
	}

	return hsl;
}

//float OX, OY;

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float3 hsl = rgb2hsl(color.rgb);

	// Coordinate of palette entry in the palette
	float2 coord;

	// Calculate position of the spectrum in the palete (identified by saturation)
	float i = hsl.z * Cols * Rows;
	coord.x = floor(fmod(i, Cols)) / Cols;
	coord.y = floor(i / Cols) / Rows;

	// Add X offset for hue
	coord.x += 0.9999 * hsl.x / Cols;
	coord.y += 0.9999 * hsl.y / Rows;

	//coord.x += OX;
	//coord.y += OY;

	// Load palette color
	color.rgb = palette.Sample(paletteSampler, coord);
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	float3 hsl = rgb2hsl(color.rgb);

	// Coordinate of palette entry in the palette
	float2 coord;

	// Calculate position of the spectrum in the palete (identified by saturation)
	float i = hsl.z * Cols * Rows;
	coord.x = floor(fmod(i, Cols)) / Cols;
	coord.y = floor(i / Cols) / Rows;

	// Add X offset for hue
	coord.x += 0.9999 * hsl.x / Cols;
	coord.y += 0.9999 * hsl.y / Rows;

	//coord.x += OX;
	//coord.y += OY;

	// Load palette color
	float4 palettecolor = palette.Sample(paletteSampler, coord);
	if ( palettecolor.a != 0 )
		palettecolor.rgb /= palettecolor.a;
	color.rgb = palettecolor.rgb * color.a;
	return color;
}
