Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float Color_GetLuminosity(float3 c)
{
	return 0.3*c.r + 0.59*c.g + 0.11*c.b;
}

float3 Color_SetLuminosity(float3 c, float lum)
{
    float d = lum - Color_GetLuminosity(c);
    c.rgb += float3(d,d,d);

	// clip back into legal range
	lum = Color_GetLuminosity(c);
    float cMin = min(c.r, min(c.g, c.b));
    float cMax = max(c.r, max(c.g, c.b));

    if(cMin < 0)
        c = lerp(float3(lum,lum,lum), c, lum / (lum - cMin));

    if(cMax > 1)
        c = lerp(float3(lum,lum,lum), c, (1 - lum) / (cMax - lum));

    return c;
}

float4 ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord)) * In.Tint;
	float4 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
	float4 O = float4(Color_SetLuminosity(L.rgb, Color_GetLuminosity(B.rgb)),L.a);

	return O;
}


float4 ps_main_pm(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 L = Demultiply(img.Sample(imgSampler,In.texCoord)) * In.Tint;
	float4 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
	float4 O = float4(Color_SetLuminosity(L.rgb, Color_GetLuminosity(B.rgb)),L.a);
	O.rgb *= O.a;

	return O;
}
