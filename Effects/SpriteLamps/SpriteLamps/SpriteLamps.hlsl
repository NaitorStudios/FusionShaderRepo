// Shader by Emil Macko
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);
Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
	float4 amb;
	int intens;
	int L1x, L1y, L1z;
	float4 L1c;
	int L2x, L2y, L2z;
	float4 L2c;
	int L3x, L3y, L3z;
	float4 L3c;
	int L4x, L4y, L4z;
	float4 L4c;
	
};
cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth, fPixelHeight;
};

float4 demultiply(float4 color)
{
	if(color.a != 0) color.rgb /= color.a;
	return color;
}

float3 light(float3 norm, float2 texCoord)
{
	norm = norm * 2.0 - 1.0;
	float3 pos = float3(texCoord.x / fPixelWidth, texCoord.y / fPixelHeight, 0.0);
	float3 col = 0.0;
	float3 lights[8] = {
		float3(L1x, L1y, L1z), L1c.rgb,
		float3(L2x, L2y, L2z), L2c.rgb,
		float3(L3x, L3y, L3z), L3c.rgb,
		float3(L4x, L4y, L4z), L4c.rgb};
	
	for(int i = 0; i < 8; i += 2)
	{
		float3 dir = lights[i] - pos;
		col += lights[i+1] * max(dot(norm, normalize(dir)), 0.0) / (length(dir) / intens);
	}
	
	col = bg.Sample(bgSampler, texCoord).rgb * (amb.rgb + col);
	
	float3 oE = max(col - 1.0, 0.0) / 3.0;
	col = min(col, 1.0) + oE.r + oE.g + oE.b;
	
	return col;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 norm = img.Sample(imgSampler, In.texCoord);
	return float4(light(norm.rgb, In.texCoord), norm.a);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float4 norm = demultiply(img.Sample(imgSampler, In.texCoord));
	return float4(light(norm.rgb, In.texCoord), 1.0) * norm.a;
}
