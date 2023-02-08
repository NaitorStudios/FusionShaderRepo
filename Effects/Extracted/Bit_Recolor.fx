
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

/*Bit number aren't float in reality but playing with float can give different result*/

float bitR,bitG,bitB;
int mod,rmod;
float stepR,stepG,stepB;

float4 ps_main( in float2 In :TEXCOORD0 ) :COLOR0
{
    float4 A = tex2D(Tex0,In);
    float4 B = tex2D(bkd,In);
    float4 O;
    O.a = A.a;
    
    //In mod 0 with use bit value to calcul the step of each component.

    if(mod==0){  

        //Init the step of each component of RGB ( min step = 1, max step 256 )

        if(bitR<=8) {stepR = 1/(pow(2,bitR)-1);}else{stepR=1/255;}
        if(bitG<=8) {stepG = 1/(pow(2,bitG)-1);}else{stepG=1/255;}
        if(bitB<=8) {stepB = 1/(pow(2,bitB)-1);}else{stepB=1/255;}
    }
    else{
        stepR=stepR/255;
        stepG=stepG/255;
        stepB=stepB/255;
    }
    O.rgb=0;
    float brMod=(B.r%stepR);
    float bgMod=(B.g%stepG);
    float bbMod=(B.b%stepB);
    
    //This ver take the current value without condition, darker
    
    /*
    O.r=B.r-brMod;
    O.g=B.g-bgMod;
    O.b=B.b-bbMod;
    */

    // This ver is a little darker, only the two higher values are round

    
    if((1%stepR==0)&&(B.r>1-stepR/2)){O.r=1;}
    else{O.r=B.r-brMod;}
    if((1%stepG==0)&&(B.g>1-stepG/2)){O.g=1;}
    else{O.g=B.g-bgMod;}
    if((1%stepB==0)&&(B.b>1-stepB/2)){O.b=1;}
    else{O.b=B.b-bbMod;}
    

    //This one compare each value before assigning a color, a little brighter
    
    /*
    if(brMod>stepR/2){O.r=(B.r+stepR)-brMod;}
    else{O.r=B.r-brMod;}
    if(bgMod>stepG/2){O.g=(B.g+stepG)-bgMod;}
    else{O.g=B.g-bgMod;}
    if(bbMod>stepB/2){O.b=(B.b+stepB)-bbMod;}
    else{O.b=B.b-bbMod;}
    */
    
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