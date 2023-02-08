sampler2D img;
sampler2D bkd : register(s1);
float fSharpen, iWidth, iHeight;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{
	float4 srcPixel = tex2D(img,In);
	float4 bgPixel = tex2D(bkd,In);

	// This bases the strength of the effect on the red channel only.
	//float fStrength = srcPixel.r * fSharpen;

	// This uses an unweighted average of the red, green and blue channels.
	float fStrength = ((srcPixel.r + srcPixel.g + srcPixel.b) / 3.0) * fSharpen;
	
	// This uses a weighted average taking into account how colors are perceived by the human eye.
	//float fStrength = dot(srcPixel, float3(0.3, 0.59, 0.11)) * fSharpen;

	bgPixel -= tex2D(bkd, float2( In.x + (1.0/iWidth), In.y + (1.0/iHeight) ))*fStrength;
	bgPixel += tex2D(bkd, float2( In.x - (1.0/iWidth), In.y - (1.0/iHeight) ))*fStrength;

	return bgPixel;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }