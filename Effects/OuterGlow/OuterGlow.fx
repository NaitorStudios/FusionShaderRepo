sampler2D img;
float alpha,radius,exponent,fPixelWidth,fPixelHeight;
float4 color;
const float2 offsets[12] = {
   -0.326212, -0.305805,
   -0.840144,  0.073580,
   -0.695914,  0.557137,
   -0.203345,  0.720716,
    0.962340, -0.094983,
    0.473434, -0.380026,
    0.519456,  0.867022,
    0.185461, -0.793124,
    0.507431,  0.164425,
    0.896420,  0.512458,
   -0.321940, -0.832615,
   -0.791559, -0.497705,
};

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {
	float glow;
    float4 fore = tex2D(img,In);
	
    //Outer glow
   	glow = fore.a;
    for(int i=0;i<12;i++)
        glow += tex2D(img,In+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]).a;
    glow /= 13;
	
	//Fill transparent areas with the glow color
	fore.rgb = lerp(color.rgb,fore.rgb,fore.a);
	fore.a = max((1-pow(1-glow,exponent))*alpha,fore.a);
	
    return fore;
}

technique BgBlur { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }