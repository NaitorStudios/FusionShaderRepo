
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
float fGlowPower;
float fGlowStrenght;
float4 fGlowColor;
float fContrast;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y));
	float4 fOldColor;
	float4 fBlurColor;
	
	//fContrast=0.0f-fContrast;
	//fGlowPower=fGlowPower*fGlowStrenght;
	fGlowStrenght=fGlowStrenght+0.5f;
	
	//Out.Color.rgb = Out.Color.rgb*(1.0f-fContrast)+(1.0f-Out.Color.rgb)*fContrast;
	Out.Color.rgb = Out.Color.rgb*(1.0f+fContrast);
	
	fOldColor=Out.Color;

	PS_OUTPUT TexT;
	PS_OUTPUT TexTL;
	PS_OUTPUT TexL;
	PS_OUTPUT TexBL;
	PS_OUTPUT TexB;
	PS_OUTPUT TexBR;
	PS_OUTPUT TexR;
	PS_OUTPUT TexTR;
	TexT.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y-fGlowPower));
	TexTL.Color = tex2D(Tex0, float2(In.Texture.x-fGlowPower,In.Texture.y-fGlowPower));
	TexL.Color = tex2D(Tex0, float2(In.Texture.x-fGlowPower,In.Texture.y));
	TexBL.Color = tex2D(Tex0, float2(In.Texture.x-fGlowPower,In.Texture.y+fGlowPower));
	TexB.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y+fGlowPower));
	TexBR.Color = tex2D(Tex0, float2(In.Texture.x+fGlowPower,In.Texture.y+fGlowPower));
	TexR.Color = tex2D(Tex0, float2(In.Texture.x+fGlowPower,In.Texture.y));
	TexTR.Color = tex2D(Tex0, float2(In.Texture.x+fGlowPower,In.Texture.y-fGlowPower));
	
	fBlurColor = (Out.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/9;
	
	Out.Color.a=fBlurColor.a+fOldColor.a;
	Out.Color.rgb=fOldColor.rgb/2+fBlurColor.rgb*fGlowStrenght;
	
	if(fOldColor.a<1.0f && fGlowPower>0.0f)
	{
		Out.Color.a=fBlurColor.a+fOldColor.a;
		Out.Color.rgb=fGlowColor.rgb*fGlowPower*100.0f*(1.0f-fOldColor.a)+fOldColor.rgb*(fOldColor.a);
	}
	else if(fOldColor.a<1.0f)
	{
		Out.Color.a=fOldColor.a;
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