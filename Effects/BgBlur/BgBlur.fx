sampler2D img;
sampler2D bkd : register(s1);
float fX,fY,fA,fPixelWidth,fPixelHeight;
const float2 offsets[12] = {
   -0.326212, -0.405805,
   -0.840144, -0.073580,
   -0.695914,  0.457137,
   -0.203345,  0.620716,
    0.962340, -0.194983,
    0.473434, -0.480026,
    0.519456,  0.767022,
    0.185461, -0.893124,
    0.507431,  0.064425,
    0.896420,  0.412458,
   -0.321940, -0.932615,
   -0.791559, -0.597705,
};

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
    float4 back = tex2D(bkd,In), fore = tex2D(img,In);	
    for(int i=0;i<12;i++)
        back += tex2D(bkd,max(0.0,min(1.0,In+float2(fX,fY)*float2(fPixelWidth,fPixelHeight)*offsets[i])));
    back /= 13;
    back += (tex2D(bkd,In)-back)*(1.0-fore.a);
    back.rgb += (fore.rgb-back.rgb)*fore.a*fA;
    back.a += fore.a;
    return back;
}

technique BgBlur { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }