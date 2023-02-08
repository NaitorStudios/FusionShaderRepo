// Start of .fx file
// Firstly, we need to include a sampler to get the object's own image.
sampler2D img : register(s0);
sampler2D myTexture : register(s1);

float2 sourceCoord;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float xGrid = int((texCoord.x * 170) / 17.0);
float yGrid = int((texCoord.y * 153) / 17.0);
float offsetX = ((texCoord.x * 170) % 17.0);
float offsetY = ((texCoord.y * 153) % 17.0);

sourceCoord.x = (xGrid * (1.0 / 10.0)) + ((1.0/160.0) * offsetX);
sourceCoord.y = (yGrid * (1.0 / 9.0)) + ((1.0/144.0) * offsetY);

// Next, we need to get the pixel's original color and opacity.
float4 newColor = tex2D( myTexture, sourceCoord );

if (int(offsetX) == 16 || int(offsetY) == 16) {
newColor.a = 0;
}

// Now we just output the new color, and close the main shader function with a closed curly brace.
return newColor;
}

// The final part of the .fx file simply identifies the shader model as version 1.1 (this is a very basic shader, so does not demand a more modern shader model).
technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
// End of .fx file
