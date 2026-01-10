
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float fX;
	float fY;
	float fA;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

static const float2 offsets[49] = {
-0.00000067, -0.00038771,
-0.00002292, -0.01330373,
-0.00019117, 0.11098164,
0.00038771, 0.22508352,
0.00019117, 0.11098164,
0.00002292, 0.01330373,
0.00000067, 0.00038771,
-0.00002292, -0.00038771,
-0.00078633, -0.01330373,
-0.00655965, 0.11098164,
0.01330373, 0.22508352,
0.00655965, 0.11098164,
0.00078633, 0.01330373,
0.00002292, 0.00038771,
-0.00019117, -0.00038771,
-0.00655965, -0.01330373,
-0.05472157, 0.11098164,
0.11098164, 0.22508352,
0.05472157, 0.11098164,
0.00655965, 0.01330373,
0.00019117, 0.00038771,
-0.00038771, -0.00038771,
-0.01330373, -0.01330373,
-0.11098164, 0.11098164,
0.22508352, 0.22508352,
0.11098164, 0.11098164,
0.01330373, 0.01330373,
0.00038771, 0.00038771,
-0.00019117, -0.00038771,
-0.00655965, -0.01330373,
-0.05472157, 0.11098164,
0.11098164, 0.22508352,
0.05472157, 0.11098164,
0.00655965, 0.01330373,
0.00019117, 0.00038771,
-0.00002292, -0.00038771,
-0.00078633, -0.01330373,
-0.00655965, 0.11098164,
0.01330373, 0.22508352,
0.00655965, 0.11098164,
0.00078633, 0.01330373,
0.00002292, 0.00038771,
-0.00000067, -0.00038771,
-0.00002292, -0.01330373,
-0.00019117, 0.11098164,
0.00038771, 0.22508352,
0.00019117, 0.11098164,
0.00002292, 0.01330373,
0.00000067, 0.00038771,
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{ 
    float4 back = bkd.Sample(bkdSampler,In.texCoord) * In.Tint, fore = img.Sample(imgSampler,In.texCoord) * In.Tint;	
    for(int i=0;i<49;i++)
        back += bkd.Sample(bkdSampler,max(0.0,min(1.0,In.texCoord+float2(fX,fY)*float2(fPixelWidth,fPixelHeight)*offsets[i])));
    back /= 13;
    back += (bkd.Sample(bkdSampler,In.texCoord)-back)*(1.0-fore.a);
    back.rgb += (fore.rgb-back.rgb)*fore.a*fA;
    back.a += fore.a;
	return back;
}

