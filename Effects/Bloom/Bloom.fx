sampler2D img;
float radius,exponent,coeff,fPixelWidth,fPixelHeight;

#define iterations 12


//Thanks to
//http://www.klopfenstein.net/lorenz.aspx/gamecomponents-the-bloom-post-processing-filter
const float2 offsets[iterations] = {
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

float4 highlight(float4 i)
{
	return pow(i,exponent)*coeff;
}

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
    float4 s = tex2D(img,In), o = highlight(s);
    for(int i=0;i<iterations;i++)
        o += highlight(tex2D(img,In+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]));
    o /= iterations+1;
    return s+highlight(o);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }