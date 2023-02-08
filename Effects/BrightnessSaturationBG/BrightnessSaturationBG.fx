sampler2D source : register(s1);

float Brightness, Saturation;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(source,In);
	
	float f = (color.r+color.g+color.b)/3;
	color.rgb = Brightness+f*(1.0f-Saturation)+color.rgb*Saturation;

	return color;
}

technique tech_main
{
	pass P0
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}