
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

static const float2 offsets[12] = {
   -0.326212, -0.405805,
   -0.840144, -0.073580,
   -0.695914,  0.457137,
   -0.203345,  0.620716,
    0.962340, -0.194983,
    0.473434, -0.480026,
    0.519456,  0.767022,
    0.185461, -0.893124,
    0.507431,  0.064425,
    0.896420,  0.412458,
   -0.321940, -0.932615,
   -0.791559, -0.597705,
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{ 
    float4 back = bkd.Sample(bkdSampler,In.texCoord), fore = img.Sample(imgSampler,In.texCoord) * In.Tint;	
    for(int i=0;i<12;i++)
        back += bkd.Sample(bkdSampler,max(0.0,min(1.0,In.texCoord+float2(fX,fY)*float2(fPixelWidth,fPixelHeight)*offsets[i])));
    back /= 13;
    back += (bkd.Sample(bkdSampler,In.texCoord)-back)*(1.0-fore.a);
    back.rgb += (fore.rgb-back.rgb)*fore.a*fA;
    back.a += fore.a;
	return back;
}

