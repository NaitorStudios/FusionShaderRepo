Texture2D<float4> tex : register(t0);
sampler texSampler : register(s0);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
    float alpha;
	float water_start;
	float water_end;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(PS_INPUT In) : SV_TARGET
{
    float4 c = tex.Sample(texSampler, In.texCoord);
    float v = acos((In.texCoord.x - 0.5) * 2.0);
    float a = In.texCoord.y >= water_start + (water_end - water_start) * sin(v) ? alpha : 1.0;

    return float4(c.rgb, c.a * a) * In.Tint;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
    float4 c = Demultiply(tex.Sample(texSampler, In.texCoord));
    float v = acos((In.texCoord.x - 0.5) * 2.0);
    float a = In.texCoord.y >= water_start + (water_end - water_start) * sin(v) ? alpha : 1.0;
	float final_alpha = c.a * a;
    return float4(c.rgb * final_alpha, final_alpha);
}