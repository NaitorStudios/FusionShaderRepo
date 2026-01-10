cbuffer PS_VARIABLES : register(b0)
{
	float imgWidth;
	float imgHeight;
	float2 offset;
	float2 pick;
};
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color : SV_TARGET;
};

Texture2D<float4> bkd : register(s1);
sampler bkdSampler : register(s1);
Texture2D<float4> pattern : register(s2);
sampler patternSampler : register(s2);


float4 ps_main(in float2 texCoord) : SV_TARGET	{
float4 inColor = bkd.Sample(bkdSampler, texCoord );
float oldLight = (0.3*inColor.r) + (0.6*inColor.g) + (0.1*inColor.b);
float newLight = int(oldLight * 25) / 25.0;

// Calculate offset of pixel within tile
offset.x = ((texCoord.x * imgWidth) % 4.0) / 4.0;
offset.y = ((texCoord.y * imgHeight) % 4.0) / 4.0;
pick.x = newLight + (offset.x / 25.0);
pick.y = offset.y;

float4 outColor = pattern.Sample(patternSampler, pick );
//float4 outColor = float4( offset.x,offset.y,1,1);
//float4 outColor = float4(newLight,newLight,newLight,1);
return outColor;
}

