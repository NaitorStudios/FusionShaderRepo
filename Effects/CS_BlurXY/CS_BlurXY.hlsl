// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fXc;
	float fYc;
};

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
	TexT.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y-fYc));
	TexTL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fXc,In.texCoord.y-fYc));
	TexL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fXc,In.texCoord.y));
	TexBL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fXc,In.texCoord.y+fYc));
	TexB.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y+fYc));
	TexBR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fXc,In.texCoord.y+fYc));
	TexR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fXc,In.texCoord.y));
	TexTR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fXc,In.texCoord.y-fYc));
	Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y));
	
	Out.Color = (Out.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/9;
	Out.Color *= In.Tint;
	
    return Out;
}

float4 GetColorPM(float2 xy)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
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
	TexT.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y-fYc));
	TexTL.Color = GetColorPM(float2(In.texCoord.x-fXc,In.texCoord.y-fYc));
	TexL.Color = GetColorPM(float2(In.texCoord.x-fXc,In.texCoord.y));
	TexBL.Color = GetColorPM(float2(In.texCoord.x-fXc,In.texCoord.y+fYc));
	TexB.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y+fYc));
	TexBR.Color = GetColorPM(float2(In.texCoord.x+fXc,In.texCoord.y+fYc));
	TexR.Color = GetColorPM(float2(In.texCoord.x+fXc,In.texCoord.y));
	TexTR.Color = GetColorPM(float2(In.texCoord.x+fXc,In.texCoord.y-fYc));
	Out.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y));
	
	Out.Color = (Out.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/9;
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
	
    return Out;
}
