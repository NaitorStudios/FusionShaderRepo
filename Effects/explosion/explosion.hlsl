struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float fTime;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{ 
  float ar = fPixelWidth / fPixelHeight;
  float2 uv = In.texCoord;
  float radius = length(float2((uv.x - 0.5) / ar, uv.y - 0.5)) + 0.1 - fTime / 20.0;
  float angle = atan2(uv.y - 0.5, (uv.x - 0.5) / ar);
  float distortion = smoothstep(0.1, 0.2, radius) * smoothstep(0.3, 0.2, radius) * smoothstep(0.0, 1.0, radius);
  float4 light = float4(1.0, 0.8, 0.7, 1.0) * smoothstep(0.5, 0.0, radius) * 1.75 - fTime / 20.0;
  uv += distortion * float2(cos(angle), sin(angle));
  return bkd.Sample(bkdSampler, uv) + light;    
}

