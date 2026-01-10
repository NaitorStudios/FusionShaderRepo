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
int iFlipX;
int iFlipY;
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
    
    float2 flippedTexture = In.Texture;
    if(iFlipX==1) flippedTexture.x = 1.0 - In.Texture.x;
    if(iFlipY==1) flippedTexture.y = 1.0 - In.Texture.y;
    Out.Color = tex2D(Tex0, flippedTexture);

    if(iH==0 || (iH==1 && flippedTexture.x >fX) || (iH==2 && flippedTexture.x <fX) ) {
    	if(iV==0 || (iV==1 && flippedTexture.y >fY) || (iV==2 && flippedTexture.y <fY) ) {
            float a = pow(max(0,min(1,sqrt(pow(flippedTexture.y-fY,2)/fRatio+pow(flippedTexture.x-fX,2)*fRatio)/fD)),fE)*fC;
            Out.Color.a *= (iInvert==1) ? 1-a : a;
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
