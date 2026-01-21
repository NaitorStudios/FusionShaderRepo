struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

Texture2D<float4> pattern : register(t1);
sampler patternSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float x;
	float y;
	float alpha;
	float width;
	float height;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 o = Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint;

	In.texCoord /= float2(fPixelWidth,fPixelHeight);
	In.texCoord += float2(x,y);
	In.texCoord /= float2(width,height);
	//In.texCoord %= 1.0;
	float4 p = pattern.Sample(patternSampler,In.texCoord);
	
	o.rgb = lerp(o.rgb,p.rgb,alpha*p.a);

    return o;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 o = Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint;
	if ( o.a > 0 )
		o.rgb /= o.a;

	In.texCoord /= float2(fPixelWidth,fPixelHeight);
	In.texCoord += float2(x,y);
	In.texCoord /= float2(width,height);
	//In.texCoord %= 1.0;
	float4 p = pattern.Sample(patternSampler,In.texCoord);
	
	o.rgb = lerp(o.rgb,p.rgb,alpha*p.a);
	o.rgb *= o.a;

    return o;
}
