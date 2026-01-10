sampler2D Tex0;
sampler2D pattern : register(s1) = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
}; 

int mode;
float x, y, alpha, width, height, fPixelWidth, fPixelHeight;

float4 ps_main(float2 In : TEXCOORD0 ) : COLOR0
{
	float4 o = tex2D(Tex0, In);
	
	In /= float2(fPixelWidth,fPixelHeight);
	In += float2(x,y);
	In /= float2(width,height);
	float4 p = tex2D(pattern,In);
	
    if (mode == 1) {
        p.rgb += o.rgb;
    } else if (mode == 2) {
        p.rgb *= o.rgb;
    }


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
