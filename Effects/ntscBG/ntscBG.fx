sampler2D img : register(s1);
sampler2D mult : register(s2);
sampler2D squig : register(s3);
float amp;
float size;
int squiginv;

float4 horizonalblur(sampler2D image, float2 uv){
	float2 tc0 = uv + float2(      0,   0);
	float2 tc1 = uv + float2( size  ,   0);
	float2 tc2 = uv + float2( size*2,   0);
	float2 tc3 = uv + float2( size*3,   0);
	float2 tc4 = uv + float2( size*4,   0);
	float2 tc5 = uv + float2(-size  ,   0);
	float2 tc6 = uv + float2(-size*2,   0);
	float2 tc7 = uv + float2(-size*3,   0);
	float2 tc8 = uv + float2(-size*4,   0);

	float4 col0 = tex2D(image, tc0);
	float4 col1 = tex2D(image, tc1);
	float4 col2 = tex2D(image, tc2);
	float4 col3 = tex2D(image, tc3);
	float4 col4 = tex2D(image, tc4);
	float4 col5 = tex2D(image, tc5);
	float4 col6 = tex2D(image, tc6);
	float4 col7 = tex2D(image, tc7);
	float4 col8 = tex2D(image, tc8);

	float4 sum = (col0 + col1 + col2 +
	              col3 + col4 + col5 +
	              col6 + col7 + col8) / 9;

	return sum;
}

float2 squigfunc(float src, float2 uv){
	float coordinate = src*amp;
	return uv + float2(coordinate,0);
}

float4 multfunc(float4 img1, float4 img2)
{
	return img1 * img2 * 2;
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float2 uv = In;
	float4 col = tex2D(img, uv);

	col = multfunc(col, tex2D(mult, uv));

	uv = squigfunc((tex2D(squig, uv).g*squiginv + (1 - squiginv) * 0.5)
	*(col.r - col.g), uv);
	col = tex2D(img, uv);

	float4 blr = horizonalblur(img, uv);
	//float4 blr = tex2D(img, uv);
	blr -= (blr.r + blr.g + blr.b)/3;
	col = blr + (col.r + col.g + col.b)/3;

	col = multfunc(col, tex2D(mult, uv));

	return col;
}

technique tech_main
{
	pass P0
	{
		//PixelShader = compile ps_2_0 ps_main();
	}
}
