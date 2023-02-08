
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
	float fBlend;
	int Mode;
	float intensity;
	float time;
};

float2 transformxy(float2 xy)
{
	if (xy.y > 0.5) {
	xy.x += ((xy.y-0.5) * intensity)*sin(time+(10*cos(xy.y)));
	}

	if (Mode == 1){
		if (xy.y < fCoeff){
			xy.y = (- xy.y / fCoeff) + xy.y + 1;
		}
	}
	else if (Mode == 2){
		if (xy.x < fCoeff){
			xy.x = (- xy.x / fCoeff) + xy.x + 1;
		}
	}
	else if (Mode == 3){
		if (xy.x > fCoeff){
			xy.x = ((xy.x - 1) * fCoeff) / (fCoeff - 1);
		}
	}
	else {
		if (xy.y > fCoeff){
			xy.y = ((xy.y - 1) * fCoeff) / (fCoeff - 1);
		}
	}
	return xy;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float2 xy = transformxy(In.texCoord);
	return float4(bg.Sample(bgSampler,xy).rgb,1.0-fBlend) * In.Tint;
}

// Premultiplied version
float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float2 xy = transformxy(In.texCoord);
	float alpha = 1.0-fBlend;
	return float4(bg.Sample(bgSampler,xy).rgb * alpha,alpha) * In.Tint;
}
