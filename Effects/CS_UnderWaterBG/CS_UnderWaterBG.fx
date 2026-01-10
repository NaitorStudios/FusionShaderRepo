
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
sampler2D Tex0 : register(s1);
float fBlur;
float fAmplitudeX;
float fPeriodsX;
float fFreqX;
float fAmplitudeY;
float fPeriodsY;
float fFreqY;

PS_OUTPUT ps_main( in PS_INPUT In )
{
	// Output pixel
    PS_OUTPUT Out;
	//SinX
	In.Texture.y = In.Texture.y + (sin((In.Texture.x+fFreqX)*fPeriodsX)*fAmplitudeX);// + 1.0f)%1.0f;
	//SinY
	In.Texture.x = In.Texture.x + (sin((In.Texture.y+fFreqY)*fPeriodsY)*fAmplitudeY);// + 1.0f)%1.0f;

    // Output pixel
    PS_OUTPUT TexTL;
    PS_OUTPUT TexBL;
    PS_OUTPUT TexBR;
    PS_OUTPUT TexTR;
	TexTL.Color = tex2D(Tex0, float2(In.Texture.x-fBlur,In.Texture.y-fBlur));
	TexBL.Color = tex2D(Tex0, float2(In.Texture.x-fBlur,In.Texture.y+fBlur));
	TexBR.Color = tex2D(Tex0, float2(In.Texture.x+fBlur,In.Texture.y+fBlur));
	TexTR.Color = tex2D(Tex0, float2(In.Texture.x+fBlur,In.Texture.y-fBlur));
	Out.Color = tex2D(Tex0, In.Texture.xy);
	
	Out.Color = (Out.Color+TexTL.Color+TexBL.Color+TexBR.Color+TexTR.Color)/5;

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