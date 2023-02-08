// Global variables
sampler2D Tex0 = sampler_state
{
  MinFilter = Anisotropic;  //antialiasing
  MagFilter = Anisotropic;
};


//Dimensions of the entire viewport in pixels.
//We will only be sampling from the upper left corner (and expanding it to the full viewport)
float fViewportWidth;
float fViewportHeight;

//Dimensions of the area we're sampling from.
float fSourceWidth;
float fSourceHeight;

//Hidden from MMF; these values are global (and thus uniform) for efficiency
float2 ViewportDims;  //(viewport width and viewport height combined)
float2 SourceDims;    //(source width and source height combined)
float2 SourceScale;   //SourceDims / ViewportDims

float4 ps_main( float4 TexCoord : TEXCOORD0 ) : COLOR0
{
	//Precalculate stuff according to viewport size
	ViewportDims = float2(fViewportWidth, fViewportHeight);
	SourceDims = float2(fSourceWidth, fSourceHeight);
	SourceScale = SourceDims / ViewportDims;

	return tex2D( Tex0, float2( TexCoord.x * SourceScale.x, TexCoord.y * SourceScale.y ) );
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