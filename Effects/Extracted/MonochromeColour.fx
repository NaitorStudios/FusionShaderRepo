//The source image
sampler2D source;

float4 keep;

//This function will be called for each pixel in our texture and returns the new color
float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{

	//Read the color of the source texture at the current position (In)
	float4 color = tex2D(source,In);
	
	if(color.r != keep.r || color.g != keep.g || color.b != keep.b) 
	{
		float4 f4 = color * float4(0.299f, 0.587f, 0.114f, 1.0f);
		float f = f4.r + f4.g + f4.b;
		color.rgb = f;
	}

	//Output the color
	return color;
}

//Use ps_main() as entry point for the shader, compile as pixel shader 2.0
technique tech_main
{
	pass P0
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}