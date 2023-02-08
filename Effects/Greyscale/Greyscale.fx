// Start of .fx file
// Firstly, we need to include a sampler to get the object's own image.
sampler2D img : register(s0);

// This shader won't require any predefined variables, so we can move straight on to the main shader function.
float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

// Next, we need to get the pixel's original color and opacity.
float4 pixelColor = tex2D( img, texCoord );

// We can then calculate the average of the red, green and blue color components (ie. the pixel's lightness).
float pixelAverage = (pixelColor.r + pixelColor.g + pixelColor.b) / 3.0;

// The pixel's new color will have red, green and blue components all equal to the average that we just calculated, while the opacity remains unchanged.
float4 newColor = float4( pixelAverage, pixelAverage, pixelAverage, pixelColor.a );

// Now we just output the new color, and close the main shader function with a closed curly brace.
return newColor;
}

// The final part of the .fx file simply identifies the shader model as version 1.1
technique tech_main	{ pass P0 { PixelShader = compile ps_1_1 ps_main(); }  }
// End of .fx file
