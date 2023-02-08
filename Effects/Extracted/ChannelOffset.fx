sampler2D img;

float Rx,Ry,Gx,Gy,Bx,By,Ax,Ay;
float fPixelWidth,fPixelHeight;

float4 texClip(sampler2D img, float2 pos)
{
	return (pos.x < 0 || pos.y < 0 || pos.x > 1 || pos.y > 1) ? 0 : tex2D(img,pos);
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(img,In);
	float2 Pixel = float2(fPixelWidth,fPixelHeight);

	color.r = texClip(img,In+Pixel*float2(Rx,Ry)).r;
	color.g = texClip(img,In+Pixel*float2(Gx,Gy)).g;
	color.b = texClip(img,In+Pixel*float2(Bx,By)).b;
	color.a = texClip(img,In+Pixel*float2(Ax,Ay)).a;

	return color;
}

technique tech_main
{
	pass P0
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}