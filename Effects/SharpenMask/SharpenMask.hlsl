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
	float fSharpen;
	int iWidth, iHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET	{
	float4 srcPixel = Demultiply(img.Sample(imgSampler,In.texCoord)) * In.Tint;
	srcPixel.a = 1.0;
	float4 bgPixel = bkd.Sample(bkdSampler,In.texCoord);

	// This bases the strength of the effect on the red channel only.
	//float fStrength = srcPixel.r * fSharpen;

	// This uses an unweighted average of the red, green and blue channels.
	float fStrength = ((srcPixel.r + srcPixel.g + srcPixel.b) / 3.0) * fSharpen;
	
	// This uses a weighted average taking into account how colors are perceived by the human eye.
	//float fStrength = dot(srcPixel, float3(0.3, 0.59, 0.11)) * fSharpen;

	bgPixel -= bkd.Sample(bkdSampler, float2( In.texCoord.x + (1.0/iWidth), In.texCoord.y + (1.0/iHeight) ))*fStrength;
	bgPixel += bkd.Sample(bkdSampler, float2( In.texCoord.x - (1.0/iWidth), In.texCoord.y - (1.0/iHeight) ))*fStrength;

	return bgPixel;
}

