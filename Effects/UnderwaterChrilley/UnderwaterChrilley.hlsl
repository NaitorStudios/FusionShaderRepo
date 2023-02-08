struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

//Enable texture wrap
//sampler2D bkd : register(s1)= sampler_state{
//   AddressU = Wrap;
//   AddressV =   Wrap;
//};
//sampler2D distort : register(s2)= sampler_state{
//   AddressU =   Wrap;
//   AddressV =   Wrap;
//};

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

Texture2D<float4> distort : register(t2);
sampler distortSampler : register(s2);

cbuffer PS_VARIABLES : register(b0)
{
	float4 fColor;
	float fDistortStr;
	float fAmplitude;
	float fFrequency;
	float fPeriods;
	bool waveEnabled;
	float fWaveAmplitude;
	float fWaveFrequency;
	float fWavePeriods;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 color = bkd.Sample(bkdSampler, float2( In.texCoord.x,In.texCoord.y));

	float4 distortColor = distort.Sample(distortSampler, float2( In.texCoord.x,In.texCoord.y));

	float2 offset = float2(fFrequency*fPixelWidth, fFrequency*fPixelHeight);
	offset.x = distortColor.r*fDistortStr;
	offset.y = distortColor.g*fDistortStr;

	color =  bkd.Sample(bkdSampler, float2(In.texCoord.x+ (sin((In.texCoord.x+fFrequency)*fPeriods)*fAmplitude)+offset.x,In.texCoord.y+ (sin((In.texCoord.x+fFrequency)*fPeriods)*fAmplitude)+offset.y));

	color.rgb += fColor.rgb;

	if(waveEnabled){
		color.a = smoothstep(0.01, 0.03, In.texCoord.y+(sin((In.texCoord.x+fWaveFrequency*fPixelHeight)*fWavePeriods)*fWaveAmplitude)+offset);
	}
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 color = bkd.Sample(bkdSampler, float2( In.texCoord.x,In.texCoord.y));
	if ( color.a > 0 )
		color.rgb /= color.a;

	float4 distortColor = distort.Sample(distortSampler, float2( In.texCoord.x,In.texCoord.y));
	if ( distortColor.a > 0 )
		distortColor.rgb /= distortColor.a;

	float2 offset = float2(fFrequency*fPixelWidth, fFrequency*fPixelHeight);
	offset.x = distortColor.r*fDistortStr;
	offset.y = distortColor.g*fDistortStr;

	color =  bkd.Sample(bkdSampler, float2(In.texCoord.x+ (sin((In.texCoord.x+fFrequency)*fPeriods)*fAmplitude)+offset.x,In.texCoord.y+ (sin((In.texCoord.x+fFrequency)*fPeriods)*fAmplitude)+offset.y));
	if ( color.a > 0 )
		color.rgb /= color.a;

	color.rgb += fColor.rgb;

	if(waveEnabled){
		color.a = smoothstep(0.01, 0.03, In.texCoord.y+(sin((In.texCoord.x+fWaveFrequency*fPixelHeight)*fWavePeriods)*fWaveAmplitude)+offset);
	}
	color.rgb *= color.a;
	return color;
}

