sampler2D img;
sampler2D pal: register(s1);
int roffset;
float4 ps_main(in float2 In : TEXCOORD0) : COLOR0 {
	float4 o = tex2D(img, In);
	int palletindex = (255.0 * o.r) - roffset;
	In.x = 0.03125 * (palletindex % 32);
	In.y = 0.03125 * (palletindex / 32);
	o.rgb = tex2D(pal, In).rgb;
	return o;
}
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}