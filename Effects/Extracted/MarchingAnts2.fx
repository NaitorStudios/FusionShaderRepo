sampler2D img;

float step;

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
	float2 iResolution = float2(fPixelWidth, fPixelHeight);

	float4 src = tex2D(img,In);
	float2 uv = In.xy / iResolution.xy;
    
	float3 stripes = 5.0  * sin( 5.0 *(In.x/iResolution.x+In.y/iResolution.y)+step);
	src.rgb += (floor(stripes)-src.rgb)*(1.0-src.a);
	if(src.a) src.a = 1.0;
	else
		for(int i=0;i<8;i++)
			if(tex2D(img,In+dirs[i]*float2(fPixelWidth,fPixelHeight)).a >= 0.5f )
				src.a = 1.0;
	return src;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }