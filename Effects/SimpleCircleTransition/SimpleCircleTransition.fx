sampler2D bg : register(s0);

uniform float circle_size = 0.5;// : hint_range(0.0, 1.05);
uniform float screen_width = 640;
uniform float screen_height = 480;

float4 ps_main(in float2 UV : TEXCOORD0) : COLOR0
{	
	float ratio = screen_width / screen_height;
	float dist = distance(0.5, float2(lerp(0.5, UV.x, ratio), UV.y));
	float ALPHA = step(dist,circle_size);
	return float4(tex2D(bg, UV).rgb, ALPHA);
	
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_a ps_main(); }}