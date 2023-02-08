
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float4 c1, c2, c3, c4;
	int tb;
	float s1, s2, s3, s4;

}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    float4 A = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord))*In.Tint;
    float4 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
    float4 O = float4(B.rgb,1.0);
    
    //calcul the greyscale value
    float Bgrb = (B.g+B.b+B.r)/3.0;

    //Change the color according to its greyscale
    if((Bgrb>=s1)){O.rgb=c1.rgb;}
    else if((Bgrb>=s2)&&(Bgrb<s1)){O.rgb=c2.rgb;}
    else if((Bgrb<s2)&&(Bgrb>=s3)){O.rgb=c3.rgb;}

    //We test if the " full black " is allowed before processing to the last color
    if(tb==1){if((Bgrb<s3)&&(Bgrb>=s4)){O.rgb=c4.rgb;}else if(Bgrb<s4){O=0.0;}}
    else{if(Bgrb<s3){O.rgb=c4.rgb;}}

    O.a=A.a;
    return O;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    float4 A = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord))*In.Tint;
    float4 B = Demultiply(bkd.Sample(bkdSampler,In.texCoord));
    float4 O = float4(B.rgb,1.0);
    
    //calcul the greyscale value
    float Bgrb = (B.g+B.b+B.r)/3.0;

    //Change the color according to its greyscale
    if((Bgrb>=s1)){O.rgb=c1.rgb;}
    else if((Bgrb>=s2)&&(Bgrb<s1)){O.rgb=c2.rgb;}
    else if((Bgrb<s2)&&(Bgrb>=s3)){O.rgb=c3.rgb;}

    //We test if the " full black " is allowed before processing to the last color
    if(tb==1){if((Bgrb<s3)&&(Bgrb>=s4)){O.rgb=c4.rgb;}else if(Bgrb<s4){O=0.0;}}
    else{if(Bgrb<s3){O.rgb=c4.rgb;}}

    O.a=A.a;
	O.rgb*=O.a;
    return O;
}



