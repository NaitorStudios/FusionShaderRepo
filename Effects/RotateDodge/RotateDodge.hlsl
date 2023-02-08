struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float angle;
	float x;
	float y;
};

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float a = radians(-angle);
	float co = cos(a);
	float si = sin(a);

	float4 B = bkd.Sample(bkdSampler,In.texCoord);

	In.texCoord -= float2(x, y);
	float temp = In.texCoord.x * co + In.texCoord.y * si + x;
	In.texCoord.y = In.texCoord.y * co - In.texCoord.x * si + y;
	In.texCoord.x = temp;

	float4 L = img.Sample(imgSampler,In.texCoord) * In.Tint;
	float4 O = L == 1.0 ? 1.0:saturate(B/(1.0-L));
	O.a = 1.0; // Apparently
	return O;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float a = radians(-angle);
	float co = cos(a);
	float si = sin(a);

	float4 B = bkd.Sample(bkdSampler,In.texCoord);

	In.texCoord -= float2(x, y);
	float temp = In.texCoord.x * co + In.texCoord.y * si + x;
	In.texCoord.y = In.texCoord.y * co - In.texCoord.x * si + y;
	In.texCoord.x = temp;

	float4 L = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( L.a != 0 )
		L.rgb /= L.a;
	float4 O = L == 1.0 ? 1.0:saturate(B/(1.0-L));
	O.a = 1.0; // Apparently
	return O;
}
