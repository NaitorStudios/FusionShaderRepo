
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
int iR;
int iG;
int iB;
int iA;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
  PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, In.Texture.xy);
	if(iR==1)
	Out.Color.r = 1-Out.Color.r;
	if(iG==1)
	Out.Color.g = 1-Out.Color.g;
	if(iB==1)
	Out.Color.b = 1-Out.Color.b;
	if(iA==1)
	Out.Color.a = 1-Out.Color.a;
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