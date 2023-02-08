sampler2D img;
sampler2D bkd : register(s1);
float	amount;
int invert;
float4 ps_main(in float2 In: TEXCOORD0) : COLOR0	{
	float4 avg = 0.0;
	for(int x=1;x<4;x++) {
		for(int y=1;y<4;y++) {
			if(invert) avg += 1.0-tex2D(bkd,float2(x,y)/4.0);
			else avg += tex2D(bkd,float2(x,y)/4.0);
		}
	}
	avg /= 25.0;
	avg.a = 0.0;
	return tex2D(img,In)+avg*amount;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }