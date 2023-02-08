// Global variables
sampler2D fg;
	
float x,y,fPixelWidth,fPixelHeight;
int limit;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 color = 0.0;
	float2 pos = float2(x,y);
	if(limit)
		pos -= floor(pos);
	pos = In-pos*float2(fPixelWidth,fPixelHeight);
	if(pos.x>=0&&pos.x<=1&&pos.y>=0&&pos.y<=1)
		color = tex2D(fg,pos);
	return color;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}