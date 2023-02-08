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
Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);
cbuffer PS_VARIABLES : register(b0)
{
	float fSat;
};
PS_OUTPUT ps_main(in PS_INPUT In)
{
	PS_OUTPUT Out;
	Out.Color = bkd.Sample(bkdSampler,In.texCoord);
	float fGrey = dot(Out.Color.rgb, float3(0.3, 0.59, 0.11));
 	Out.Color.rgb = lerp(fGrey, Out.Color, fSat).rgb;
	Out.Color *= In.Tint;
	return Out;
}
PS_OUTPUT ps_main_pm(in PS_INPUT In)
{
	PS_OUTPUT Out;
	Out.Color = bkd.Sample(bkdSampler,In.texCoord);
	float fGrey = dot(Out.Color.rgb, float3(0.3, 0.59, 0.11));
 	Out.Color.rgb = lerp(fGrey, Out.Color, fSat).rgb;
	Out.Color *= In.Tint;
	return Out;
}
