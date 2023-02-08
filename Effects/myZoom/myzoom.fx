// Start of .fx file
// As usual, we start with the standard sampler...
sampler2D img : register(s0);

// This shader will include a predefined variable to control the zoom level.
float zoom;

// Again, we have the standard main shader function...
float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float2 newCoord = ((texCoord-0.5)/zoom)+0.5;

float4 newColor = tex2D( img, newCoord );
return newColor;
}
// The final part of the .fx file simply identifies the shader model as version 1.4 (this shader is a little more complex, and will give an error message with shader models below version 1.4).
technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
// End of .fx file
