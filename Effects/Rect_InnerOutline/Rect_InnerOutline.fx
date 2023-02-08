sampler2D img;

float oWidth, oHeight, bSize;
float4 bColor;
float bAlpha;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	// Retrieve the current Pixel's RGBA Float4.
	float4 o = tex2D(img,In);

	// Determine Displayed Pixel's position.
	float xFract = (In.x * oWidth)%(oWidth - bSize);
	float yFract = (In.y * oHeight)%(oHeight - bSize);

	// Border Process:
	if (xFract <= bSize || yFract <= bSize) 
	{ 
		//Alpha
		o = lerp(o, float4(bColor.rgb,1.0), bAlpha);
	}

	return o;

}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}