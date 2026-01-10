sampler2D img;
float4 color;
float2 dirs[] = {
1.0, 0.0,
0.0, 1.0,
-1.0, 0.0,
0.0, -1.0
};
float fPixelWidth, fPixelHeight;
float4 ps_main(in float2 In: TEXCOORD0) : COLOR0	{
	float4 src = tex2D(img,In);
              float4 ex[] = {
                    tex2D(img,In + dirs[0]*fPixelWidth),
                    tex2D(img,In + dirs[1]*fPixelHeight),
                    tex2D(img,In + dirs[2]*fPixelWidth),
                    tex2D(img,In + dirs[3]*fPixelHeight)
              };

              for(int i=0;i<4;i++){
                    if(src.a<0.5 && ex[i].a>=0.5)
                    src.rgb= ex[i].rgb*7.5;	  
                    src.a += ex[i].a;
                    
              }
	return src;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }