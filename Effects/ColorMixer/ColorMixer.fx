sampler2D img;

float4 r, g, b;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 i = tex2D(img,In);
	float4 o = float4(0,0,0,i.a);
	o.rgb = r.rgb*i.r + g.rgb*i.g + b.rgb*i.b;	
	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}