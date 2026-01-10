struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float4 color;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

static float2 dirs[] = {
1.0, 0.0,
0.0, 1.0,
-1.0, 0.0,
0.0, -1.0
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 src = img.Sample(imgSampler,In.texCoord) * In.Tint;
	src.rgb += (color.rgb-src.rgb)*(1.0-src.a);
	if(src.a)
		src.a = 1.0;
	else
	{
		for(int i=0;i<4;i++)
		{
			if(img.Sample(imgSampler,In.texCoord+dirs[i]*float2(fPixelWidth,fPixelHeight)).a)
			{
				src.a = 1.0;
				break;
			}
		}
	}
	return src;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 src = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( src.a != 0 )
		src.rgb /= src.a;
	src.rgb += (color.rgb-src.rgb)*(1.0-src.a);
	if(src.a)
		src.a = 1.0;
	else
	{
		for(int i=0;i<4;i++)
		{
			if(img.Sample(imgSampler,In.texCoord+dirs[i]*float2(fPixelWidth,fPixelHeight)).a)
			{
				src.a = 1.0;
				break;
			}
		}
		src.rgb *= src.a;
	}
	return src;
}
