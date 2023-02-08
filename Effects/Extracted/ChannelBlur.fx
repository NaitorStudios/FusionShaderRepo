
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
float fCoeff;
int iR;
int iG;
int iB;
int iA;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    PS_OUTPUT TexT;
    PS_OUTPUT TexTL;
    PS_OUTPUT TexL;
    PS_OUTPUT TexBL;
    PS_OUTPUT TexB;
    PS_OUTPUT TexBR;
    PS_OUTPUT TexR;
    PS_OUTPUT TexTR;
	TexT.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y-fCoeff));
	TexTL.Color = tex2D(Tex0, float2(In.Texture.x-fCoeff,In.Texture.y-fCoeff));
	TexL.Color = tex2D(Tex0, float2(In.Texture.x-fCoeff,In.Texture.y));
	TexBL.Color = tex2D(Tex0, float2(In.Texture.x-fCoeff,In.Texture.y+fCoeff));
	TexB.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y+fCoeff));
	TexBR.Color = tex2D(Tex0, float2(In.Texture.x+fCoeff,In.Texture.y+fCoeff));
	TexR.Color = tex2D(Tex0, float2(In.Texture.x+fCoeff,In.Texture.y));
	TexTR.Color = tex2D(Tex0, float2(In.Texture.x+fCoeff,In.Texture.y-fCoeff));
	Out.Color = tex2D(Tex0, In.Texture.xy);
	if(iR==1)
	Out.Color.r = (Out.Color.r+TexT.Color.r+TexTL.Color.r+TexL.Color.r+TexBL.Color.r+TexB.Color.r+TexBR.Color.r+TexR.Color.r+TexTR.Color.r)/9;
	if(iG==1)
	Out.Color.g = (Out.Color.g+TexT.Color.g+TexTL.Color.g+TexL.Color.g+TexBL.Color.g+TexB.Color.g+TexBR.Color.g+TexR.Color.g+TexTR.Color.g)/9;
	if(iB==1)
	Out.Color.b = (Out.Color.b+TexT.Color.b+TexTL.Color.b+TexL.Color.b+TexBL.Color.b+TexB.Color.b+TexBR.Color.b+TexR.Color.b+TexTR.Color.b)/9;
	if(iA==1)
	Out.Color.a = (Out.Color.a+TexT.Color.a+TexTL.Color.a+TexL.Color.a+TexBL.Color.a+TexB.Color.a+TexBR.Color.a+TexR.Color.a+TexTR.Color.a)/9;
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