
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
const int iR=0;
const int iG=0;
const int iB=0;
const int iA=0;
const float iFr=1;
const float iFg=1;
const float iFb=1;
const float iFa=1;
float channels[4];

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = tex2D(Texture0,In.Texture);
    channels[0] = Out.Color.r;
    channels[1] = Out.Color.g;
    channels[2] = Out.Color.b;
    channels[3] = Out.Color.a;
    
    Out.Color.r = Out.Color.r+(channels[iR]-Out.Color.r)*iFr;
    Out.Color.g = Out.Color.g+(channels[iG]-Out.Color.g)*iFg;
    Out.Color.b = Out.Color.b+(channels[iB]-Out.Color.b)*iFb;
    Out.Color.a = Out.Color.a+(channels[iA]-Out.Color.a)*iFa;
    
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