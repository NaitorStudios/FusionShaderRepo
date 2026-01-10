sampler2D img;

float4 c;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	//Retrieve the current Pixel's RGBA Float4 Value apply to a inline Float4 value.
	float4 o = tex2D(img,In);
	
	o.rgb = c.rgb;
	
	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}