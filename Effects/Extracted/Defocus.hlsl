
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 Texture : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> Tex0 : register(t1);
sampler Tex0Sampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float fCoeff;
	float fBlack;
	float fDesat;
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
	TexT.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x,In.Texture.y-fCoeff));
	TexTL.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x-fCoeff,In.Texture.y-fCoeff));
	TexL.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x-fCoeff,In.Texture.y));
	TexBL.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x-fCoeff,In.Texture.y+fCoeff));
	TexB.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x,In.Texture.y+fCoeff));
	TexBR.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x+fCoeff,In.Texture.y+fCoeff));
	TexR.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x+fCoeff,In.Texture.y));
	TexTR.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x+fCoeff,In.Texture.y-fCoeff));
	Out.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x,In.Texture.y));
	Out.Color = (4*Out.Color+2*TexT.Color+TexTL.Color+2*TexL.Color+TexBL.Color+2*TexB.Color+TexBR.Color+2*TexR.Color+TexTR.Color)/16;
	float fGrey = dot(Out.Color.rgb, float3(0.3, 0.59, 0.11));
 	Out.Color.rgb = lerp(Out.Color,fGrey, fDesat).rgb;
	Out.Color.rgb *= 1-fBlack;
    Out.Color *= In.Tint;
    return Out;
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
	TexT.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x,In.Texture.y-fCoeff));
	TexTL.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x-fCoeff,In.Texture.y-fCoeff));
	TexL.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x-fCoeff,In.Texture.y));
	TexBL.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x-fCoeff,In.Texture.y+fCoeff));
	TexB.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x,In.Texture.y+fCoeff));
	TexBR.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x+fCoeff,In.Texture.y+fCoeff));
	TexR.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x+fCoeff,In.Texture.y));
	TexTR.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x+fCoeff,In.Texture.y-fCoeff));
	Out.Color = Tex0.Sample(Tex0Sampler,float2(In.Texture.x,In.Texture.y));
	Out.Color = (4*Out.Color+2*TexT.Color+TexTL.Color+2*TexL.Color+TexBL.Color+2*TexB.Color+TexBR.Color+2*TexR.Color+TexTR.Color)/16;
	float fGrey = dot(Out.Color.rgb, float3(0.3, 0.59, 0.11));
 	Out.Color.rgb = lerp(Out.Color,fGrey, fDesat).rgb;
	Out.Color.rgb *= 1-fBlack;
    Out.Color *= In.Tint;
    return Out;
}