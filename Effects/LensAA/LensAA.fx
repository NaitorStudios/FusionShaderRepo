// Global variables
sampler2D lens : register(s0) = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
};
sampler2D bg : register(s1) = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
};
float height, fCoeff, fBase;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	height = fBase+tex2D(lens,In).r*fCoeff;
	In.x += (height-1.0f)/2.0;
	In.y += (height-1.0f)/2.0;
	return tex2D(bg,float2(In.x/height,In.y/height));
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}