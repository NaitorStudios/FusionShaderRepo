sampler2D bkd : register(s1); 

float Rx,Ry,Gx,Gy,Bx,By,Ax,Ay;
float fPixelWidth,fPixelHeight;

float4 texClip(sampler2D bkd, float2 pos)
{
	return (pos.x < 0 || pos.y < 0 || pos.x > 1 || pos.y > 1) ? 0 : tex2D(bkd,pos);
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(bkd,In);
	float2 Pixel = float2(fPixelWidth,fPixelHeight);

	color.r = texClip(bkd,In+Pixel*float2(Rx,Ry)).r;
	color.g = texClip(bkd,In+Pixel*float2(Gx,Gy)).g;
	color.b = texClip(bkd,In+Pixel*float2(Bx,By)).b;
	color.a = texClip(bkd,In+Pixel*float2(Ax,Ay)).a;

	return color;
}

technique tech_main
{
	pass P0
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}