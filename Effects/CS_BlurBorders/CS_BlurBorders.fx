
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

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y));
	
	if(Out.Color.a<1.0f)
	{
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
		
		Out.Color = (Out.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/9;
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