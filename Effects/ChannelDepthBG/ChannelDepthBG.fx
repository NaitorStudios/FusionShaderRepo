
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
sampler2D Samp2D_Bkg : register(s1);
uniform float fOffset;
uniform float fR;
uniform float fG;
uniform float fB;
bool BG;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    //Out.Color = tex2D(Tex0, In.Texture);
    Out.Color = BG ? tex2D(Samp2D_Bkg, In.Texture) : tex2D(Tex0, In.Texture);

	fR *= 1.001;
	fG *= 1.001;
	fB *= 1.001;
	if(fR>0) Out.Color.r = int((Out.Color.r+fOffset)/fR*255)/255*fR;
	if(fB>0) Out.Color.g = int((Out.Color.g+fOffset)/fG*255)/255*fG;
	if(fG>0) Out.Color.b = int((Out.Color.b+fOffset)/fB*255)/255*fB;
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