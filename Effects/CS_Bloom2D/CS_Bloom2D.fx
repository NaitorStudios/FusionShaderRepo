
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
float fBloomPower;
float fBloomStrenght;
float fContrast;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y));
	float4 fOldColor;
	float4 fBlurColor;
	float4 fTemp;
	float fOld;
	float fBlur;
	
	fOldColor=Out.Color;

	PS_OUTPUT TexT;
	PS_OUTPUT TexTL;
	PS_OUTPUT TexL;
	PS_OUTPUT TexBL;
	PS_OUTPUT TexB;
	PS_OUTPUT TexBR;
	PS_OUTPUT TexR;
	PS_OUTPUT TexTR;
	TexT.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y-fBloomPower));
	TexTL.Color = tex2D(Tex0, float2(In.Texture.x-fBloomPower,In.Texture.y-fBloomPower));
	TexL.Color = tex2D(Tex0, float2(In.Texture.x-fBloomPower,In.Texture.y));
	TexBL.Color = tex2D(Tex0, float2(In.Texture.x-fBloomPower,In.Texture.y+fBloomPower));
	TexB.Color = tex2D(Tex0, float2(In.Texture.x,In.Texture.y+fBloomPower));
	TexBR.Color = tex2D(Tex0, float2(In.Texture.x+fBloomPower,In.Texture.y+fBloomPower));
	TexR.Color = tex2D(Tex0, float2(In.Texture.x+fBloomPower,In.Texture.y));
	TexTR.Color = tex2D(Tex0, float2(In.Texture.x+fBloomPower,In.Texture.y-fBloomPower));
	
	fBlurColor = (Out.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/9;
	
	fTemp = fOldColor * float4(0.299f, 0.587f, 0.114f, 1.0f);
	fOld = fTemp.r + fTemp.g + fTemp.b;
	
	fTemp = fBlurColor * float4(0.299f, 0.587f, 0.114f, 1.0f);
	fBlur = fTemp.r + fTemp.g + fTemp.b;
	
	Out.Color.a=fOldColor.a;
	
	if(fBlur>fOld)
	{
		Out.Color.rgb=fOldColor.rgb*(1.0f-fBloomStrenght)+fBlurColor.rgb*fBloomStrenght;
	}
	else
	{
		Out.Color.rgb=fOldColor.rgb;
	}
	Out.Color.rgb = Out.Color.rgb*(1.0f+fContrast);
	
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