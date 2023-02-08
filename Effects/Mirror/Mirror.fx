
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

float fB;
int iM;
int iS;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
        Out.Color = tex2D(Tex0,In.Texture.xy);
        //Mirror X
        if(iM==0) {
	if(iS==0 && In.Texture.x > fB)
         Out.Color = tex2D(Tex0, float2(fB-(In.Texture.x-fB),In.Texture.y));
	else
	 if(iS==1 && In.Texture.x < fB) Out.Color = tex2D(Tex0, float2(fB-(In.Texture.x-fB),In.Texture.y));
        }
        //Mirror Y
        if(iM==1) {
	if(iS==0 && In.Texture.y > fB)
         Out.Color = tex2D(Tex0, float2(In.Texture.x,fB-(In.Texture.y-fB)));
	else
	 if(iS==1 && In.Texture.y < fB) Out.Color = tex2D(Tex0, float2(In.Texture.x,fB-(In.Texture.y-fB)));
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