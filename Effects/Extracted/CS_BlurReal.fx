
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
int nSteps;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	int i;
	float fCoeffCurrent=fCoeff;
	
	if(nSteps>0)
	{
		PS_OUTPUT TexT;
		PS_OUTPUT TexTL;
		PS_OUTPUT TexL;
		PS_OUTPUT TexBL;
		PS_OUTPUT TexB;
		PS_OUTPUT TexBR;
		PS_OUTPUT TexR;
		PS_OUTPUT TexTR;
		PS_OUTPUT TexF;
		
		Out.Color.rgba=0.0f;
			
		for(i=0;i<nSteps;i++)
		{	
			TexT.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y-fCoeffCurrent));
			TexTL.Color = tex2D(Tex0, float2(In.Texture.x-fCoeff,In.Texture.y-fCoeff));
			TexL.Color = tex2D(Tex0, float2(In.Texture.x-fCoeffCurrent,In.Texture.y));
			TexBL.Color = tex2D(Tex0, float2(In.Texture.x-fCoeff,In.Texture.y+fCoeff));
			TexB.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y+fCoeffCurrent));
			TexBR.Color = tex2D(Tex0, float2(In.Texture.x+fCoeff,In.Texture.y+fCoeff));
			TexR.Color = tex2D(Tex0, float2(In.Texture.x+fCoeffCurrent,In.Texture.y));
			TexTR.Color = tex2D(Tex0, float2(In.Texture.x+fCoeff,In.Texture.y-fCoeff));
			TexF.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y));
			
			Out.Color = Out.Color+(TexF.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/(9*nSteps);
			
			fCoeffCurrent=fCoeffCurrent+fCoeff;
		}
	}
	else
	{
		Out.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y));
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
        PixelShader  = compile ps_3_0 ps_main();
    }  
}