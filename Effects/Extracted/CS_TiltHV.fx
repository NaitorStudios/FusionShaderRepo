
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

float fTH;
float fTV;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	float fCoeffH = 1-abs(fTH);
	float fCoeffV = 1-abs(fTV);

	if(fTH>=0 && fTV>=0)
	{
		Out.Color = tex2D(Tex0, float2((In.Texture.x-In.Texture.y*fTH)/fCoeffH,(In.Texture.y-In.Texture.x*fTV)/fCoeffV));
	}
	else if(fTH>=0)
	{
		Out.Color = tex2D(Tex0, float2((In.Texture.x-In.Texture.y*fTH)/fCoeffH,(In.Texture.y-In.Texture.x*fTV)/fCoeffV+fTV));
	}
	else if(fTV>=0)
	{
		Out.Color = tex2D(Tex0, float2((In.Texture.x-In.Texture.y*fTH)/fCoeffH+fTH,(In.Texture.y-In.Texture.x*fTV)/fCoeffV));
	}
	else
	{
		Out.Color = tex2D(Tex0, float2((In.Texture.x-In.Texture.y*fTH)/fCoeffH+fTH,(In.Texture.y-In.Texture.x*fTV)/fCoeffV+fTV));
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