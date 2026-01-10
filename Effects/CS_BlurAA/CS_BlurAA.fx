
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

float3 alphaOverlay(float4 Color, float4 output)
{
	float new_a = 1-(1-output.a)*(1-Color.a) ;
	output.rgb = (output.rgb*output.a+Color.rgb*Color.a*(1-output.a))/new_a ;
	return output.rgb;
}

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
	Out.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y));
	
	Out.Color.a = (Out.Color.a+TexT.Color.a+TexTL.Color.a+TexL.Color.a+TexBL.Color.a+TexB.Color.a+TexBR.Color.a+TexR.Color.a+TexTR.Color.a)/9;
	
	Out.Color.rgb = alphaOverlay(Out.Color,TexT.Color);
	Out.Color.rgb = alphaOverlay(Out.Color,TexTL.Color);
	Out.Color.rgb = alphaOverlay(Out.Color,TexL.Color);
	Out.Color.rgb = alphaOverlay(Out.Color,TexBL.Color);
	Out.Color.rgb = alphaOverlay(Out.Color,TexB.Color);
	Out.Color.rgb = alphaOverlay(Out.Color,TexBR.Color);
	Out.Color.rgb = alphaOverlay(Out.Color,TexR.Color);
	Out.Color.rgb = alphaOverlay(Out.Color,TexTR.Color);
	
    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }  
}