sampler2D Tex0;
sampler2D pattern : register(s1); 

float x, y, alpha, width, height, fPixelWidth, fPixelHeight;

float4 ps_main(float2 In : TEXCOORD0 ) : COLOR0
{
	float4 o = tex2D(Tex0,In);
	
	In /= float2(fPixelWidth,fPixelHeight);
	In += float2(x,y);
	In /= float2(width,height);
	//In.x %= 0.5;
	//In.y %= 1.0;
	float4 p = tex2D(pattern,In);
	
	o.rgb = lerp(o.rgb,p.rgb,alpha*p.a);

    return o;
}

technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 ps_main();
    }

}
