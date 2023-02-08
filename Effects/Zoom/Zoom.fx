// Start of .fx file
// As usual, we start with the standard sampler...
sampler2D img : register(s0);

// This shader will include a predefined variable to control the zoom level.
float zoom;

// Again, we have the standard main shader function...
float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

// Next, we calculate the coordinates from which we will sample. Since coordinates range from 0 to 1, we can scale an image simply by dividing texCoord by the zoom factor. The other parts are there to ensure we zoom in on the centre of the image.
float2 newCoord = ((texCoord-0.5)/zoom)+0.5;

// Again, we sample the new pixel, and output the result.
float4 newColor = tex2D( img, newCoord );
return newColor;
}

// The final part of the .fx file simply identifies the shader model as version 2.0.
technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
// End of .fx file
