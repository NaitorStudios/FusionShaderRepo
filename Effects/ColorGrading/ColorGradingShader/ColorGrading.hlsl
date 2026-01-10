
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

Texture2D<float4> LUTa : register(t2);
sampler LUTaSampler : register(s2);

Texture2D<float4> LUTb : register(t3);
sampler LUTbSampler : register(s3);

cbuffer PS_VARIABLES : register(b0)
{
	int lutSize, addLUT;
	float blend;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float maxColor = lutSize - 1.0;
	float4 imgColor = saturate(bkd.Sample(bkdSampler, In.texCoord));
	float halfColX = 0.5 / (lutSize * lutSize);
	float halfColY = 0.5 / lutSize;
	float threshold = maxColor / lutSize;
	
	float xOffset = halfColX + imgColor.r * threshold / lutSize;
	float yOffset = halfColY + imgColor.g * threshold;
	float cell = floor(imgColor.b * maxColor);
	
	float2 lutPos = float2(cell / lutSize + xOffset, yOffset);
	float4 gradedColA = LUTa.Sample(LUTaSampler, lutPos);
	if ( addLUT == 1 ) {
		float4 gradedColB = LUTb.Sample(LUTbSampler, lutPos);
		return lerp(gradedColB, gradedColA, blend);
	} else
		return lerp(imgColor, gradedColA, blend);
}