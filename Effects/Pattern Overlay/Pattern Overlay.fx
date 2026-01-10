sampler2D Tex0;

float xScale;
float yScale;

float fPixelWidth;
float fPixelHeight;

float map(float value, float originalMin, float originalMax, float newMin, float newMax) {
	return (value - originalMin) / (originalMax - originalMin) * (newMax - newMin) + newMin;
}

float process_axis(float coord, float pixel, float texture_pixel, float start, float end) {
	// If in the right/top border region, map normally.
	if (coord > 1.0 - end * pixel) {
		return map(coord, 1.0 - end * pixel, 1.0, 1.0 - texture_pixel * end, 1.0);
	}
	// If in the middle region, repeat (tile) the source.
	else if (coord > start * pixel) {
		float outMiddle = (1.0 - end * pixel) - start * pixel;           // Length of middle region in output space.
		float texMiddle = (1.0 - end * texture_pixel) - start * texture_pixel; // Length of middle region in texture space.
		float t = (coord - start * pixel) / outMiddle;  // Normalize coordinate within the middle.
		t = frac(t);                                    // Wrap it to [0,1] for tiling.
		return start * texture_pixel + t * texMiddle;   // Map to the middle region in the source.
	}
	// Left/bottom border: map normally.
	else {
		return map(coord, 0.0, start * pixel, 0.0, start * texture_pixel);
	}
}

float4 ps_main(float2 In : TEXCOORD0 ) : COLOR0
{
	// Compute a "corner" size. With the original math this equals 1/3 of a pixel in UV space.
	float2 cornerSize = float2(1.0 / fPixelWidth / 3.0, 1.0 / fPixelHeight / 3.0);
	
	// For X: 
	//	- pixel = output width in pixels = fPixelWidth / xScale 
	//	- texture_pixel = source texture width (fPixelWidth)
	// For Y similarly.
	float2 mappedUV = float2(
		process_axis(In.x, fPixelWidth / xScale, fPixelWidth, cornerSize.x, cornerSize.x),
		process_axis(In.y, fPixelHeight / yScale, fPixelHeight, cornerSize.y, cornerSize.y)
	);
	return tex2D(Tex0, mappedUV);
}

technique PostProcess
{
	pass p1
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}
