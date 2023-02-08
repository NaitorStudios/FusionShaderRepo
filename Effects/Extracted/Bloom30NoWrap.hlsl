struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};


Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);


cbuffer PS_VARIABLES : register(b0)
{
	float radius;
	float exponent;
	float coeff;
};


cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

#define iterations 30

static const float2 offsets[iterations] = {
1, -0,
0.489074, -0.103956,
0.913545, -0.406737,
0.404509, -0.293893,
0.669131, -0.743145,
0.25, -0.433013,
0.309017, -0.951057,
0.0522642, -0.497261,
-0.104529, -0.994522,
-0.154509, -0.475528,
-0.5, -0.866025,
-0.334565, -0.371572,
-0.809017, -0.587785,
-0.456773, -0.203368,
-0.978148, -0.207912,
-0.5, -0,
-0.978148, 0.207912,
-0.456773, 0.203368,
-0.809017, 0.587786,
-0.334565, 0.371572,
-0.5, 0.866025,
-0.154509, 0.475528,
-0.104528, 0.994522,
0.0522642, 0.497261,
0.309017, 0.951056,
0.25, 0.433013,
0.669131, 0.743145,
0.404508, 0.293893,
0.913546, 0.406736,
0.489074, 0.103956,
};


float4 highlight(float4 i)
{
	return pow(abs(i),exponent)*coeff;
}


float4 ps_main(PS_INPUT In) : SV_TARGET
{ 
    float4 s = Texture0.Sample(TextureSampler0,In.texCoord);
	float4 o = highlight(s);
    for(int i=0;i<iterations;i++)
        o += highlight(Texture0.Sample(TextureSampler0,In.texCoord+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]));
    o /= (iterations+1);
	o = s + highlight(o);
    return o*In.Tint;	// (s+highlight(o))*In.Tint;
}





