
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

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

#define iterations 12

//Thanks to
//http://www.klopfenstein.net/lorenz.aspx/gamecomponents-the-bloom-post-processing-filter
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
