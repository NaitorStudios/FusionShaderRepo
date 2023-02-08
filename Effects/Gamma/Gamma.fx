sampler2D img;

float factor;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 o = tex2D(img,In);
	o.rgb = lerp(o.rgb,sin(o.rgb*3.14159),factor);
	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}