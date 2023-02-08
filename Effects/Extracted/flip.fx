// Start of .fx file
// Firstly, we need to include a sampler to get the object's own image.
sampler2D img : register(s0);

// This shader will provide predefined variables (and checkboxes) so that the user can select whether to flip the image horizontally or vertically or both.
int flipX;
int flipY;

// Now on to the main shader function...
float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

// We'll start by creating a new set of coordinates, which is where we'll sample to get the new pixel color.
float2 newCoord = texCoord;

// If the variable "flipX" is equal to "1" (ie. if the checkbox has been checked), we will invert the x axis - remember that coordinates are not measured in actual pixels, but range from 0 to 1, so to invert the axis we just subtract from 1.
if ( flipX == 1 ) {
newCoord.x = 1.0 - texCoord.x;
}

// And now the same for the y axis...
if ( flipY == 1 ) {
newCoord.y = 1.0 - texCoord.y;
}

// Next we sample a pixel from the new coordinates.
float4 newColor = tex2D( img, newCoord );

// And then we just output the new color and close the main shader function.
return newColor;
}

// The final part of the .fx file simply identifies the shader model as version 1.4 (this shader is a little more complex, and will give an error message with shader models below version 1.4).
technique tech_main	{ pass P0 { PixelShader = compile ps_1_4 ps_main(); }  }
// End of .fx file