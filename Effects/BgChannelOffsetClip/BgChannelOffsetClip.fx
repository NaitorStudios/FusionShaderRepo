sampler2D bkd : register(s1) = sampler_state {
MinFilter = Point;
MagFilter = Point;
AddressU = border;
AddressV = border;
BorderColor = float4(0.45, 0.45, 0.45, 0.0);
};

float Rx,Ry,Gx,Gy,Bx,By,Ax,Ay;
float fPixelWidth,fPixelHeight;
float x1, y1, x2, y2;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(bkd,In);
	float2 Pixel = float2(fPixelWidth,fPixelHeight);

	color.r = tex2D(bkd,In+Pixel*float2(Rx,Ry)).r;
	color.g = tex2D(bkd,In+Pixel*float2(Gx,Gy)).g;
	color.b = tex2D(bkd,In+Pixel*float2(Bx,By)).b;
	color.a = tex2D(bkd,In+Pixel*float2(Ax,Ay)).a;

	if (In.x < x1 || In.y < y1 || In.x > 1-x2 || In.y > 1-y2 ) { discard; }
	return color;
}

technique tech_main
{
	pass P0
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}