struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float radius;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

#define iterations 12

static const float2 offsets[iterations] = {
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
//1, -0,
//0.489074, -0.103956,
//0.913545, -0.406737,
//0.404509, -0.293893,
//0.669131, -0.743145,
//0.25, -0.433013,
//0.309017, -0.951057,
//0.0522642, -0.497261,
//-0.104529, -0.994522,
//-0.154509, -0.475528,
//-0.5, -0.866025,
//-0.334565, -0.371572,
//-0.809017, -0.587785,
//-0.456773, -0.203368,
//-0.978148, -0.207912,
//-0.5, -0,
//-0.978148, 0.207912,
//-0.456773, 0.203368,
//-0.809017, 0.587786,
//-0.334565, 0.371572,
//-0.5, 0.866025,
//-0.154509, 0.475528,
//-0.104528, 0.994522,
//0.0522642, 0.497261,
//0.309017, 0.951056,
//0.25, 0.433013,
//0.669131, 0.743145,
//0.404508, 0.293893,
//0.913546, 0.406736,
//0.489074, 0.103956,
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    float4 o = bg.Sample(bgSampler,In.texCoord);
	float4 s = o;	
    for(int i=0;i<iterations;i++)
        o += bg.Sample(bgSampler,In.texCoord+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]);
    o /= iterations+1;
 
 	float4 fade = img.Sample(imgSampler,In.texCoord) * In.Tint;
    return lerp(s,o,fade.r);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    float4 o = bg.Sample(bgSampler,In.texCoord);
	if ( o.a != 0 )
		o.rgb /= o.a;
	float4 s = o;	
    for(int i=0;i<iterations;i++)
	{
		float4 tmp = bg.Sample(bgSampler,In.texCoord+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]);
		if ( tmp.a != 0 )
			tmp.rgb /= tmp.a;
        o += tmp;
	}
    o /= iterations+1;
 
 	float4 fade = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( fade.a != 0 )
		fade.rgb /= fade.a;
    o = lerp(s,o,fade.r) * o.a;
	return o;
}
