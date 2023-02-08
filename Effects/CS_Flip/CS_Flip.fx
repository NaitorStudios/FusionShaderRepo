
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

//Tint color
float4 fColor	: COLOR0;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	if(iFlipX==0 && iFlipY==0)
	{
		Out.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y));
	}
	else if(iFlipX==1 && iFlipY==0)
	{
		Out.Color = tex2D(Tex0, float2(1.0-In.Texture.x,In.Texture.y));
	}
	else if(iFlipX==0 && iFlipY==1)
	{
		Out.Color = tex2D(Tex0, float2(In.Texture.x,1.0-In.Texture.y));
	}
	else
	{
		Out.Color = tex2D(Tex0, float2(1.0-In.Texture.x,1.0-In.Texture.y));
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