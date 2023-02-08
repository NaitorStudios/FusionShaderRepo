
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
sampler2D Tex0;

float fD;
float fE;
float fX;
float fY;
float fC;
float fRatio;
int iInvert;
int iH;
int iV;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = tex2D(Tex0,In.Texture);
    if(iH==0 || (iH==1 && In.Texture.x >fX) || (iH==2 && In.Texture.x <fX) ) {
    	if(iV==0 || (iV==1 && In.Texture.y >fY) || (iV==2 && In.Texture.y <fY) ) {
		    float a = pow(max(0,min(1,sqrt(pow(In.Texture.y-fY,2)/fRatio+pow(In.Texture.x-fX,2)*fRatio)/fD)),fE)*fC;
		    if(iInvert==1) Out.Color.a *= 1-a;
		    else Out.Color.a *= a;
		  }
    }
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