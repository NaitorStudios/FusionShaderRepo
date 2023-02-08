
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

float fA;
float fX;
float fY;
float fSx;
float fSy;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	In.Texture.x -= fSx;
	In.Texture.y -= fSy;
	fX += 0.5f;
	fY += 0.5f;
	fA *= 0.0174532925f;
	float Ray = sqrt(pow(In.Texture.x-fX,2)+pow(In.Texture.y-fY,2));
	float Angle;
	if(In.Texture.y-fY>0)
	{
		Angle = acos((In.Texture.x-fX)/Ray);
	}
	else
	{
		Angle = 0-acos((In.Texture.x-fX)/Ray);
	}
		
    In.Texture.x = fX + cos(Angle+fA)*Ray;
    In.Texture.y = fY + sin(Angle+fA)*Ray;
    if(In.Texture.x >= 0 && In.Texture.x <= 1 && In.Texture.y >= 0 && In.Texture.y <= 1)
    Out.Color = tex2D(Tex0, In.Texture.xy);
    else Out.Color = float4(0,0,0,0);
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