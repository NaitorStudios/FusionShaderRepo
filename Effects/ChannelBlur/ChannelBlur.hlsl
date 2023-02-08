
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
	float fCoeff;
	int iR;
	int iG;
	int iB;
	int iA;
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
	TexT.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y-fCoeff));
	TexTL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fCoeff,In.texCoord.y-fCoeff));
	TexL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fCoeff,In.texCoord.y));
	TexBL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fCoeff,In.texCoord.y+fCoeff));
	TexB.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y+fCoeff));
	TexBR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fCoeff,In.texCoord.y+fCoeff));
	TexR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fCoeff,In.texCoord.y));
	TexTR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fCoeff,In.texCoord.y-fCoeff));
	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord.xy);
	if(iR==1)
	Out.Color.r = (Out.Color.r+TexT.Color.r+TexTL.Color.r+TexL.Color.r+TexBL.Color.r+TexB.Color.r+TexBR.Color.r+TexR.Color.r+TexTR.Color.r)/9;
	if(iG==1)
	Out.Color.g = (Out.Color.g+TexT.Color.g+TexTL.Color.g+TexL.Color.g+TexBL.Color.g+TexB.Color.g+TexBR.Color.g+TexR.Color.g+TexTR.Color.g)/9;
	if(iB==1)
	Out.Color.b = (Out.Color.b+TexT.Color.b+TexTL.Color.b+TexL.Color.b+TexBL.Color.b+TexB.Color.b+TexBR.Color.b+TexR.Color.b+TexTR.Color.b)/9;
	if(iA==1)
	Out.Color.a = (Out.Color.a+TexT.Color.a+TexTL.Color.a+TexL.Color.a+TexBL.Color.a+TexB.Color.a+TexBR.Color.a+TexR.Color.a+TexTR.Color.a)/9;
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
	TexT.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y-fCoeff));
	TexTL.Color = GetColorPM(float2(In.texCoord.x-fCoeff,In.texCoord.y-fCoeff));
	TexL.Color = GetColorPM(float2(In.texCoord.x-fCoeff,In.texCoord.y));
	TexBL.Color = GetColorPM(float2(In.texCoord.x-fCoeff,In.texCoord.y+fCoeff));
	TexB.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y+fCoeff));
	TexBR.Color = GetColorPM(float2(In.texCoord.x+fCoeff,In.texCoord.y+fCoeff));
	TexR.Color = GetColorPM(float2(In.texCoord.x+fCoeff,In.texCoord.y));
	TexTR.Color = GetColorPM(float2(In.texCoord.x+fCoeff,In.texCoord.y-fCoeff));
	Out.Color = GetColorPM(In.texCoord.xy);
	if(iR==1)
	Out.Color.r = (Out.Color.r+TexT.Color.r+TexTL.Color.r+TexL.Color.r+TexBL.Color.r+TexB.Color.r+TexBR.Color.r+TexR.Color.r+TexTR.Color.r)/9;
	if(iG==1)
	Out.Color.g = (Out.Color.g+TexT.Color.g+TexTL.Color.g+TexL.Color.g+TexBL.Color.g+TexB.Color.g+TexBR.Color.g+TexR.Color.g+TexTR.Color.g)/9;
	if(iB==1)
	Out.Color.b = (Out.Color.b+TexT.Color.b+TexTL.Color.b+TexL.Color.b+TexBL.Color.b+TexB.Color.b+TexBR.Color.b+TexR.Color.b+TexTR.Color.b)/9;
	if(iA==1)
	Out.Color.a = (Out.Color.a+TexT.Color.a+TexTL.Color.a+TexL.Color.a+TexBL.Color.a+TexB.Color.a+TexBR.Color.a+TexR.Color.a+TexTR.Color.a)/9;
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
  return Out;
}
