sampler2D img;
sampler2D bkd : register(s1);
float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {
	float4 o = tex2D(img,In);
	o.rgb = 1.0-tex2D(bkd,In).rgb;
	return o;
}
technique tech_main {pass P0 {PixelShader=compile ps_2_0 ps_main();}}