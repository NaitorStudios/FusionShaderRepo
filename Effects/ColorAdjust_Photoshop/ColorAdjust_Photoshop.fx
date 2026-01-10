float Hue;         // in degrees, -180..+180
float Saturation;  // in percent, -100..+100
float Lightness;   // in percent, -100..+100

sampler Samp : register(S0);

// Convert from RGB [0..1] to H, S, L in [0..1]
float3 RGBtoHSL(float3 c)
{
	// Find min/max of r,g,b
	float mn = min(c.r, min(c.g, c.b));
	float mx = max(c.r, max(c.g, c.b));
	float delta = mx - mn;

	float h = 0.0;
	float s = 0.0;
	float l = (mx + mn) * 0.5;

	// If not a gray color...
	if (delta > 1e-5)
	{
		// Saturation
		if (l < 0.5) 
		{
			s = delta / (mx + mn);
		}
		else
		{
			s = delta / (2.0 - mx - mn);
		}
		
		// Hue
		float rd = (((mx - c.r) / 6.0) + (delta * 0.5)) / delta;
		float gd = (((mx - c.g) / 6.0) + (delta * 0.5)) / delta;
		float bd = (((mx - c.b) / 6.0) + (delta * 0.5)) / delta;

		if (c.r == mx)      h = bd - gd;
		else if (c.g == mx) h = (1.0 / 3.0) + rd - bd;
		else                h = (2.0 / 3.0) + gd - rd;

		// Wrap hue into [0..1]
		if (h < 0.0) h += 1.0;
		if (h > 1.0) h -= 1.0;
	}

	return float3(h, s, l);
}

// Helper to get channel based on hue offset
float Hue2RGB(float p, float q, float t)
{
	if (t < 0.0) t += 1.0;
	if (t > 1.0) t -= 1.0;

	float result = 0.0;

	if (t < 1.0/6.0)
	{
		result = p + (q - p) * 6.0 * t;
	}
	else if (t < 1.0/2.0)
	{
		result = q;
	}
	else if (t < 2.0/3.0)
	{
		result = p + (q - p) * (2.0/3.0 - t) * 6.0;
	}
	else
	{
		result = p;
	}

	return result;
}

// Convert from HSL in [0..1] to RGB [0..1]
float3 HSLtoRGB(float3 hsl)
{
    float h = hsl.x;
    float s = hsl.y;
    float l = hsl.z;

    float3 rgb;

    // Initialize to grayscale by default
    rgb.r = l;
    rgb.g = l;
    rgb.b = l;

    // Only modify rgb if saturation is significant
    if (s >= 1e-5)
    {
        float q = (l < 0.5) ? (l * (1.0 + s)) : (l + s - (l * s));
        float p = 2.0 * l - q;

        rgb.r = Hue2RGB(p, q, h + (1.0 / 3.0));
        rgb.g = Hue2RGB(p, q, h);
        rgb.b = Hue2RGB(p, q, h - (1.0 / 3.0));
    }

    return rgb;
}

// Main pixel shader
float4 mainPS(float2 uv : TEXCOORD) : COLOR
{
	// Fetch the original color
	float4 color = tex2D(Samp, uv);

	// Convert to HSL
	float3 hsl = RGBtoHSL(color.rgb);

	// Photoshop-like Hue shift: (Hue is degrees in [-180..180])
	// Convert to fraction of a full turn, then wrap [0..1]
	float hueShift = Hue / 360.0;
	hsl.x = frac(hsl.x + hueShift);

	// Photoshop-like Saturation shift: (Saturation in [-100..100])
	// Multiply the current sat by (1 + S/100).
	float satFactor = 1.0 + (Saturation / 100.0);
	hsl.y = saturate(hsl.y * satFactor);

	// Photoshop-like Lightness shift: (Lightness in [-100..100])
	// Add (L/100) to the HSL "lightness" and clamp.
	float lightOffset = Lightness / 200.0;
	hsl.z = saturate(hsl.z + lightOffset);

	// Convert back to RGB
	float3 finalRGB = HSLtoRGB(hsl);

	// Store in color
	color.rgb = finalRGB;

	return color;
}

technique TransformTexture
{
	pass p0
	{
		PixelShader = compile ps_2_b mainPS();
	}
}
