sampler2D img = sampler_state {
MinFilter = point;
MagFilter = point;
AddressU = border;
AddressV = border;
BorderColor = float4(1.0,1.0,1.0,0.0);
};

float4 sColor;
float size, fOpacity;
float fPixelWidth, fPixelHeight;


float4 ps_main(in float2 In: TEXCOORD0) : COLOR0
{
	// get color of pixels:
	float4 color = tex2D( img, In );
	float alpha = 4*tex2D( img, In ).a;
	alpha -= tex2D( img, In + float2( size * fPixelWidth, 0.0f ) ).a;
	alpha -= tex2D( img, In + float2( -size * fPixelWidth, 0.0f ) ).a;
	alpha -= tex2D( img, In + float2( 0.0f, size * fPixelHeight ) ).a;
	alpha -= tex2D( img, In + float2( 0.0f, -size * fPixelHeight ) ).a;

	// calculate resulting color
	color.a = lerp(0.0, color.a, fOpacity);
	if (alpha > 0)
	{
		color = float4(sColor.rgb, alpha );
	}
	return color;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }