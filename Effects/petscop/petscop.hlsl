struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> mult : register(t1);
sampler multSampler : register(s1);

Texture2D<float4> squig : register(t2);
sampler squigSampler : register(s2);

cbuffer PS_VARIABLES : register(b0)
{
	int squiginv;
	float amp;
	float size;
}

float4 horizonalblur(float2 uv){

	float2 tc0 = uv + float2(      0,   0);
	float2 tc1 = uv + float2( size  ,   0);
	float2 tc2 = uv + float2( size*2,   0);
	float2 tc3 = uv + float2( size*3,   0);
	float2 tc4 = uv + float2( size*4,   0);
	float2 tc5 = uv + float2(-size  ,   0);
	float2 tc6 = uv + float2(-size*2,   0);
	float2 tc7 = uv + float2(-size*3,   0);
	float2 tc8 = uv + float2(-size*4,   0);

	float4 col0 = img.Sample(imgSampler, tc0);
	float4 col1 = img.Sample(imgSampler, tc1);
	float4 col2 = img.Sample(imgSampler, tc2);
	float4 col3 = img.Sample(imgSampler, tc3);
	float4 col4 = img.Sample(imgSampler, tc4);
	float4 col5 = img.Sample(imgSampler, tc5);
	float4 col6 = img.Sample(imgSampler, tc6);
	float4 col7 = img.Sample(imgSampler, tc7);
	float4 col8 = img.Sample(imgSampler, tc8);
	
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

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float2 uv = In.texCoord;
	float4 col = img.Sample(imgSampler, uv);

	col = multfunc(col, mult.Sample(multSampler, uv));

	uv = squigfunc((squig.Sample(squigSampler, uv).g * squiginv + (1 - squiginv) * 0.5)
	*(col.r - col.g), uv);
	col = img.Sample(imgSampler, uv);

	float4 blr = horizonalblur(uv);
	
	blr -= (blr.r + blr.g + blr.b)/3;
	col = blr + (col.r + col.g + col.b)/3;

	col = multfunc(col, mult.Sample(multSampler, uv));

	return col;
}

