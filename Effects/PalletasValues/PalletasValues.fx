sampler2D img;
float4 c[24];
int roffset;
float4 ps_main(in float2 In : TEXCOORD0) : COLOR0 {
	float4 o = tex2D(img, In);
	int palletindex = (255.0 * o.r) - roffset;
	if(palletindex < 0 || palletindex >= 24) o.a = 0; // Make non pallet values transparent.
                else o.rgb = c[palletindex].rgb;
	return o;
}
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}