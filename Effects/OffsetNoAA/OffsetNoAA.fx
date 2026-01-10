sampler2D img;
sampler2D bg : register(s1);

float width,height,fPixelWidth,fPixelHeight;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 shift = tex2D(img,In);
	float2 off = float2(width*fPixelWidth,height*fPixelHeight);
	off.x *= 2*(shift.r-0.5);
	off.y *= 2*(shift.g-0.5);
	float4 o = tex2D(bg,In+off);
	o += tex2D(bg,In+off);
	o /= 2;
	o.a = shift.a;
	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}