sampler2D img = sampler_state {
AddressU = border;
AddressV = border;
BorderColor = float4(1.0,1.0,1.0,0.0);
};
float radius,exponent,fPixelWidth,fPixelHeight, xOffset, yOffset;
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
    float4 fore = tex2D(img,In);
    float blur = fore.a;
    
    //Blur the alpha channel
    for(int i=0;i<12;i++)
        blur += tex2D(img,In+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]+float2(xOffset, yOffset)).a;
    blur /= 13;
    
	//Blend between shadow color and foreground
	fore.rgb = lerp(color.rgb,fore.rgb,pow(blur,exponent));
	
    return fore;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }