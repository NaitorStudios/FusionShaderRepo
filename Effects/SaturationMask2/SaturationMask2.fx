sampler2D img;
sampler2D bkd : register(s1);

float Intensity;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	float4 srcPixel = tex2D(img,In);
	float4 bgPixel = tex2D(bkd,In);
	float fGrey = dot(bgPixel, float3(0.3, 0.59, 0.11));
 	bgPixel.rgb = lerp(fGrey, bgPixel, (srcPixel.r+srcPixel.g+srcPixel.b) * Intensity / 3.0).rgb ;
	//bgPixel.a = srcPixel.a;	
	return bgPixel;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }