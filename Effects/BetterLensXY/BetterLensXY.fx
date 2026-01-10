// Global variables
sampler2D lens;
sampler2D bg : register(s1) = sampler_state {MinFilter = linear; MagFilter = linear;};
float width, height, zoomx, zoomy, fBase;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	width = fBase+tex2D(lens,In).r*zoomx;
	height = fBase+tex2D(lens,In).r*zoomy;
	In.x += (width-1.0f)/2.0;
	In.y += (height-1.0f)/2.0;
	return tex2D(bg,float2(In.x/width,In.y/height));
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}