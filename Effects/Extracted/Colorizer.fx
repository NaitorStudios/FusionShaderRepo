sampler2D img;
sampler2D bkd : register(s1);

float rr, rg, rb, gr, gg, gb, br, bg, bb;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 a = tex2D(img, In);
	float4 i = tex2D(bkd, In);
	float4 o = 1.0;
	o.rgb = float3(rr, rg, rb)*i.r + float3(gr, gg, gb)*i.g + float3(br, bg, bb)*i.b;	
	o.rgb = lerp(i.rgb, o.rgb, a.rgb);
	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}