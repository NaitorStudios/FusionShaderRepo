sampler2D img;
float fPixelWidth,fPixelHeight,x,y,r,s;
int i;
float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
	float4 ret = tex2D(img,In);
	float tmp = sqrt(pow(In.x/fPixelWidth-x,2)+pow(In.y/fPixelHeight-y,2))/r;
	tmp = pow(tmp,s);
	ret.a *= i?1-tmp:tmp;
	return ret;
}

technique Shader { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }