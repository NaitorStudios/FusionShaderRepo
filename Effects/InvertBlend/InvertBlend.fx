// Global variables
sampler2D fg;
sampler2D bg : register(s1);

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 src = tex2D(fg,In);
	float3 inv = 1.0-src.rgb;
	float4 bck = tex2D(bg,In);
	//Blend between src and inv based on |fore-back|
	return float4(inv+(src.rgb-inv)*abs(src.rgb-bck.rgb),src.a);
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}