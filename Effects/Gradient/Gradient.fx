
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Texture0;

const float4 fArgb  = 1;
const float fAa     = 1;
const float4 fBrgb  = 1;
const float fBa     = 0;
const float fCoeff  = 1;
const float fOffset = 0;
const float fFade   = 1;
const int iT        = 0;
const int iF        = 0;
const int iR        = 0;
const int iMask     = 0;
float Temp;
float Gx;
float Gy;
float Ga;
float3 Gcol;
PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Gx = In.Texture.x;
    Gy = In.Texture.y;
    if(iF==1) {
    Gx = 1-Gx;
    Gy = 1-Gy;
    }
    if(iR==1) {
    Temp = Gy;
    Gy = Gx;
    Gx = Temp;
    }
    Out.Color = tex2D(Texture0,In.Texture.xy);
    //GRADIENT TYPES
    if(iT==0) {
    Gcol = fArgb+(fBrgb-fArgb)*(Gx+fOffset)*fCoeff;
    Ga = fAa+(fBa-fAa)*(Gx+fOffset)*fCoeff;
    }
    if(iT==1) {
    if(iR==1) Temp = 1-Gx; else Temp = Gx;
    Gcol = fArgb+(fBrgb-fArgb)*(Gy*Temp+fOffset)*fCoeff;
    Ga = fAa+(fBa-fAa)*(Gy*Temp+fOffset)*fCoeff;
    }  
    if(iT==2) {
    Gcol = fArgb+(fBrgb-fArgb)*abs(sin(Gx*fCoeff+fOffset));
    Ga = fAa+(fBa-fAa)*abs(sin(Gx*fCoeff+fOffset));
    } 
    if(iMask==1) Out.Color.a *= Ga;
    else Out.Color.a = Ga;
    Out.Color.rgb += (Gcol-Out.Color.rgb)*fFade;
    return Out;
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