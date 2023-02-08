sampler2D img;

float2 Texture : TEXCOORD0;
float4 Position : POSITION;
float Wsize, Hsize, oWsize, oHsize, iAlpha, oAlpha;
bool iInvert, oInvert;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	//Retrieve the current Pixel's RGBA Float4.
	float4 o = tex2D(img,In);

	//Determine Displayed Pixel's position.
	float xFract = (In.x * Wsize)%(Wsize - oWsize);
	float yFract = (In.y * Hsize)%(Hsize - oHsize);

	//Process:
	//Inner Shape
	if (xFract <= oWsize || yFract <= oHsize) 
	{ 
		//Alpha
		o.a = o.a * oAlpha;

		//Invert RGB
		if (oInvert) {o.rgb = 1.0-o.rgb;}
	 }
	//Outer Shape
	else 
	{ 
		//Alpha
		o.a = o.a * iAlpha; 

		//Invert RGB
		if (iInvert) {o.rgb = 1.0-o.rgb;}
	}


	
	//Return Output
	return o;

}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}