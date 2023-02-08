sampler2D img ;

float step;
float oWidth;
float oHeight;

float2 dirs[8] = {
-1.0,-1.0,
 0.0,-1.0,
 1.0,-1.0,
-1.0, 0.0,
 1.0, 0.0,
-1.0, 1.0,
 0.0, 1.0,
 1.0, 1.0,
};

float fPixelWidth, fPixelHeight;
float4 ps_main(in float2 In: TEXCOORD0) : COLOR0
{
	float4 src = tex2D(img,In);
    
	float3 stripes = oWidth * 5.0 / fPixelWidth * sin(oWidth * 5.0 / fPixelWidth*(In.x/fPixelWidth+In.y/fPixelHeight)+step);
	src.rgb += (floor(stripes)-src.rgb)*(1.0-src.a);
	if(src.a) src.a = 1.0;
	else
		for(int i=0;i<8;i++)
			if(tex2D(img,In+dirs[i]/float2(oWidth,oHeight)).a >= 0.5f )
				src.a = 1.0;
	return src;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }