sampler2D img = sampler_state {
AddressU = border;
AddressV = border;
BorderColor = float4(1.0,1.0,1.0,0.0);
};
float iRadius,iExponent,oAlpha,oRadius,oExponent,fPixelWidth,fPixelHeight;
float4 iColor,oColor;
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
    
    //Inner glow
    glow = fore.a;
    for(int i=0;i<12;i++)
        glow += tex2D(img,In+iRadius*float2(fPixelWidth,fPixelHeight)*offsets[i]).a;
    glow /= 13;
    
	//Blend between to glow color based on blurred alpha
	fore.rgb = lerp(iColor.rgb,fore.rgb,pow(glow,iExponent));
	
    //Outer glow
   	glow = fore.a;
    for(int i=0;i<12;i++)
        glow += tex2D(img,In+oRadius*float2(fPixelWidth,fPixelHeight)*offsets[i]).a;
    glow /= 13;
	
	//Fill transparent areas with the glow color
	fore.rgb = lerp(oColor.rgb,fore.rgb,fore.a);
	fore.a = max((1-pow(1-glow,oExponent))*oAlpha,fore.a);
	
    return fore;
}

technique BgBlur { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }