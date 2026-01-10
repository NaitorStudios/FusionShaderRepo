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
    float4 ex[] = {
        img.Sample(imgSampler,In.texCoord + dirs[0]*fPixelWidth),
        img.Sample(imgSampler,In.texCoord + dirs[1]*fPixelHeight),
        img.Sample(imgSampler,In.texCoord + dirs[2]*fPixelWidth),
        img.Sample(imgSampler,In.texCoord + dirs[3]*fPixelHeight)
    };
	for(int i=0;i<4;i++){
        if(src.a<0.5 && ex[i].a>=0.5)
			src.rgb= ex[i].rgb*7.5;	  
        src.a += ex[i].a;                  
    }	
	return src;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 src = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( src.a != 0 )
		src.rgb /= src.a;
	float4 ex[] = {
        img.Sample(imgSampler,In.texCoord + dirs[0]*fPixelWidth),
        img.Sample(imgSampler,In.texCoord + dirs[1]*fPixelHeight),
        img.Sample(imgSampler,In.texCoord + dirs[2]*fPixelWidth),
        img.Sample(imgSampler,In.texCoord + dirs[3]*fPixelHeight)
    };
	for(int i=0;i<4;i++){
        if(src.a<0.5 && ex[i].a>=0.5)
			src.rgb= ex[i].rgb*7.5;	  
        src.a += ex[i].a;                  
    }	
	return src; 
}
