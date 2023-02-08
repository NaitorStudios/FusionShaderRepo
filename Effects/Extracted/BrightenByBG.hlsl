struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float	amount;
	int invert;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 avg = 0.0;
	for(int x=1;x<4;x++) {
		for(int y=1;y<4;y++) {
			if(invert) avg += 1.0-bkd.Sample(bkdSampler,float2(x,y)/4.0);
			else avg += bkd.Sample(bkdSampler,float2(x,y)/4.0);
		}
	}
	avg /= 25.0;
	avg.a = 0.0;
	return img.Sample(imgSampler,In.texCoord) * In.Tint + avg*amount;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 avg = 0.0;
	for(int x=1;x<4;x++) {
		for(int y=1;y<4;y++) {
			if(invert) avg += 1.0-bkd.Sample(bkdSampler,float2(x,y)/4.0);
			else avg += bkd.Sample(bkdSampler,float2(x,y)/4.0);
		}
	}
	avg /= 25.0;
	avg.a = 0.0;
	
	float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	color += avg*amount;
	color.rgb *= color.a;
	return color;
}
