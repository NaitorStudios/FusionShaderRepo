struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float fCoeff;
	float fAngle;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float Dist = distance(In.texCoord.xy, float2(0.5,0.5)) * 2;
	if (Dist < 1.0){
		float Angle = atan2(In.texCoord.y - 0.5, In.texCoord.x - 0.5) + pow(1 - Dist,2) * fAngle;
		Dist = (pow(Dist,fCoeff)) / 2;
		In.texCoord.x = cos(Angle) * Dist + 0.5;
		In.texCoord.y = sin(Angle) * Dist + 0.5;
	}
 	return bg.Sample(bgSampler,In.texCoord.xy);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float Dist = distance(In.texCoord.xy, float2(0.5,0.5)) * 2;
	if (Dist < 1.0){
		float Angle = atan2(In.texCoord.y - 0.5, In.texCoord.x - 0.5) + pow(1 - Dist,2) * fAngle;
		Dist = (pow(Dist,fCoeff)) / 2;
		In.texCoord.x = cos(Angle) * Dist + 0.5;
		In.texCoord.y = sin(Angle) * Dist + 0.5;
	}
 	return bg.Sample(bgSampler,In.texCoord.xy);
}