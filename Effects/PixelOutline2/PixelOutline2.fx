sampler2D img = sampler_state {
MinFilter = none;
MagFilter = none;
};
float4 color;
float2 dirs[] = {
1.0, 0.0,
0.0, 1.0,
-1.0, 0.0,
0.0, -1.0
};
float fPixelWidth, fPixelHeight, pWidth, pHeight;
float4 ps_main(in float2 In: TEXCOORD0) : COLOR0	{
	float4 src = tex2D(img,In);
	src.rgb += (color-src.rgb)*(1.0-src.a);
	if(src.a) src.a = 1.0;
	else
		for(int i=0;i<4;i++)
			if(tex2D(img,In+dirs[i]*float2(pWidth*fPixelWidth,pHeight*fPixelHeight)).a)
				src.a = 1.0;
	return src;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }