struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float progress;
	float angle;
	float feather;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

static const float2 center = 0.5;

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample(Tex0Sampler , In.texCoord));
	float rAngle = radians(angle-90);
	float2 dir = float2(cos(rAngle), sin(rAngle));
	dir = normalize(dir);
	dir /= abs(dir.x)+abs(dir.y);
	float d = dir.x * center.x + dir.y * center.y;
	float m =
		(1.0-step(progress, 0.0)) * // there is something wrong with our formula that makes m not equals 0.0 with progress is 0.0
		(1.0 - smoothstep(-feather, 0.0, dir.x * In.texCoord.x + dir.y * In.texCoord.y - (d-0.5+progress*(1.+feather))));
	float alpha = lerp(color.a, 0.0, m);
	color.a = alpha;
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample(Tex0Sampler , In.texCoord));
	float rAngle = radians(angle-90);
	float2 dir = float2(cos(rAngle), sin(rAngle));
	dir = normalize(dir);
	dir /= abs(dir.x)+abs(dir.y);
	float d = dir.x * center.x + dir.y * center.y;
	float m =
		(1.0-step(progress, 0.0)) * // there is something wrong with our formula that makes m not equals 0.0 with progress is 0.0
		(1.0 - smoothstep(-feather, 0.0, dir.x * In.texCoord.x + dir.y * In.texCoord.y - (d-0.5+progress*(1.+feather))));
	float alpha = lerp(color.a, 0.0, m);
	color.a = alpha;
	color.rgb *= color.a;
	return color;
}