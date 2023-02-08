sampler2D img = sampler_state {
    MinFilter = POINT;
    MagFilter = POINT;
};

float rX,rY,rW,rH,rA,gX,gY,gW,gH,gA,bX,bY,bW,bH,bA;
float fPixelWidth,fPixelHeight;

float4 texClip(sampler2D img, float2 pos) {
	return (pos.x < 0 || pos.y < 0 || pos.x > 1 || pos.y > 1) ? 0 : tex2D(img,pos);
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 color;
	float2 Pixel = float2(fPixelWidth,fPixelHeight);
	
	float2 redCoord   = float2((In.x+0.5*(rW-1.0f)-(rX*fPixelWidth)) /rW,
							   (In.y+0.5*(rH-1.0f)-(rY*fPixelHeight))/rH);
							   
	float2 greenCoord = float2((In.x+0.5*(gW-1.0f)-(gX*fPixelWidth)) /gW,
							   (In.y+0.5*(gH-1.0f)-(gY*fPixelHeight))/gH);
							   
	float2 blueCoord  = float2((In.x+0.5*(bW-1.0f)-(bX*fPixelWidth)) /bW,
							   (In.y+0.5*(bH-1.0f)-(bY*fPixelHeight))/bH);
	
	color.r = texClip(img,redCoord  ).r;
	color.g = texClip(img,greenCoord).g;
	color.b = texClip(img,blueCoord ).b;
	
	color.a  = texClip(img,redCoord  ).a / 3.0;
	color.a += texClip(img,greenCoord).a / 3.0;
	color.a += texClip(img,blueCoord ).a / 3.0;

	return color;
}

technique tech_main
{
	pass P0
	{
		PixelShader = compile ps_2_0 ps_main();
	}
}