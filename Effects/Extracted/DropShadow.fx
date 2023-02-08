sampler2D Texture0;
float fPixelWidth,fPixelHeight;
float x, y, xScale, yScale, xSkew, ySkew, xCenter, yCenter;
float angle, alpha, radius;
float4 color;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{ 
	//Source color
	float4 ret = tex2D(Texture0, In);

	//Center coord
	xCenter *= fPixelWidth;
	yCenter *= fPixelHeight;
	float2 center = float2(xCenter, yCenter);
	
	//Determine shadow pixel
	float2 pixel;
	if(angle)
	{
		float theta = angle/180.0*3.154159;
		float2 point = float2(cos(theta)*x - sin(theta)*y, sin(theta)*x + cos(theta)*y);
		pixel = In - float2(point.x*fPixelWidth, point.y*fPixelHeight);
	}
	//No angle, skip some calculations
	else
	{
		pixel = In - float2(x*fPixelWidth, y*fPixelHeight);
	}
	
	//Apply skew
	pixel.x += xSkew * (In.y - yCenter);
	pixel.y += ySkew * (In.x - xCenter);
	
	//Apply scale
	pixel = (pixel-center) / float2(xScale, yScale) + center;

	//Exit if no shadow
	if(pixel.x < 0 || pixel.x > 1 || pixel.y < 0 || pixel.y > 1) {}
	else
	{
		float4 shadow = color;
		shadow.a = tex2D(Texture0, pixel).a*alpha;
		//Thank, you Wikipedia. Thanks. *sniffs*
		float new_a = 1 - (1-ret.a) * (1-shadow.a);
		ret.rgb = (ret.rgb*ret.a + shadow.rgb*shadow.a*(1-ret.a)) / new_a;
		ret.a = new_a;
	}
	
	return ret;
}

technique Shader { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }