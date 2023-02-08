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
	float4 fC;
	float fT;
	int iE;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

static const float2 S[] = {
-1.0, 0.0,
0.0, -1.0,
0.0, 1.0,
1.0, 0.0,
-1.0, -1.0,
1.0, -1.0,
1.0, 1.0,
-1.0, 1.0
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float2 PSize = float2(fPixelWidth, fPixelHeight);
	float4 tex = img.Sample(imgSampler,In.texCoord);
	float outline = 0.0;
	
	for(int i=0; i<4+4*iE; i++)
	{
		outline = max(outline,img.Sample(imgSampler, In.texCoord+PSize*fT*S[i]).a);
		outline = max(outline,img.Sample(imgSampler, In.texCoord+PSize*fT*S[i]).a);
	}
	outline = outline - tex.a;
	return lerp(tex,fC,outline) * In.Tint;
}


