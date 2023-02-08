
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

//Tint color
float4 fW;
float4 fR;
float4 fG;
float4 fB;
float fCoeff;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, In.Texture);
	
	//Grey
	if((fW.r>0.0f || fW.g>0.0f || fW.b>0.0f) &&
		Out.Color.r>Out.Color.g-fCoeff &&
		Out.Color.r<Out.Color.g+fCoeff &&
		Out.Color.r>Out.Color.b-fCoeff &&
		Out.Color.r<Out.Color.b+fCoeff)
	{
		Out.Color.rgb = Out.Color.rgb*fW.rgb;
	}
	//Red
	else if((fR.r>0.0f || fR.g>0.0f || fR.b>0.0f) && 
		Out.Color.r>0.0f && Out.Color.g<fCoeff && Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.r*fR.rgb;
	}
	//Green
	else if((fG.r>0.0f || fG.g>0.0f || fG.b>0.0f) && 
		Out.Color.g>0.0f &&	Out.Color.r<fCoeff && Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.g*fG.rgb;
	}
	//Blue
	else if((fB.r>0.0f || fB.g>0.0f || fB.b>0.0f) && 
		Out.Color.b>0.0f &&	Out.Color.r<fCoeff && Out.Color.g<fCoeff)
	{
		Out.Color.rgb = Out.Color.b*fB.rgb;
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