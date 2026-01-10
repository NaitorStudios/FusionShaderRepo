sampler2D img;
sampler2D bkd : register(s1);

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

float4 ps_main(float4 color : COLOR0,in float2 In : TEXCOORD0) : COLOR0
{
	float4 L = tex2D(img,In);
	float4 B = tex2D(bkd,In);
	return float4(Color_SetLuminosity(L.rgb, Color_GetLuminosity(B.rgb)),L.a);
}


technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
