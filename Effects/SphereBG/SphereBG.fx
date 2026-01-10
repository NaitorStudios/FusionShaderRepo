
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
sampler2D Texture0 : register(s1);
float fC = 1;
float fP = 5;
float fX = 0.5;
float fY = 0.5;
float fPow = 1;
const int iRem = 0;

PS_OUTPUT ps_main( in PS_INPUT In )
{
   // Output pixel
   PS_OUTPUT Out;
   fX = 1-fX; 
   fY = 1-fY;
   //float dist = pow(fP,pow(sqrt(pow(fX-In.Texture.x,2)+pow(fY-In.Texture.y,2)),fPow));
   float dist = pow(fP,pow(sqrt(pow(fX-In.Texture.x,2)+pow(fY-In.Texture.y,2)),fPow));
   fC += (fP-1)*0.5; //Adjust zoom automaticly
   fC *= 1+(1-dist);
   fC = max(0,fC);
   In.Texture.x = In.Texture.x + fX*(fC-1.0f);
   In.Texture.y = In.Texture.y + fY*(fC-1.0f);
   Out.Color = tex2D(Texture0, float2(In.Texture.x/fC,In.Texture.y/fC));
   if(iRem == 1 && (In.Texture.x/fC < 0 || In.Texture.x/fC > 1 || In.Texture.y/fC < 0 || In.Texture.y/fC > 1)) Out.Color.a = 0;
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