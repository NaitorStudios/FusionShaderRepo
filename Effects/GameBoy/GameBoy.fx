
// Pixel shader input structure
struct PS_INPUT
{
    float4 C   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0;
sampler2D bkd : register(s1);

float4 c1, c2, c3, c4;
int tb;
float s1, s2, s3, s4;

float4 ps_main( in float2 In :TEXCOORD0 ) :COLOR0
{
    float4 A = tex2D(Tex0,In);
    float4 B = tex2D(bkd,In);
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

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}