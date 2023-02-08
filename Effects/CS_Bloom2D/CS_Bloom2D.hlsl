
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
	float fBloomPower;
	float fBloomStrenght;
	float fContrast;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y));
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
	TexT.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y-fBloomPower));
	TexTL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fBloomPower,In.texCoord.y-fBloomPower));
	TexL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fBloomPower,In.texCoord.y));
	TexBL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fBloomPower,In.texCoord.y+fBloomPower));
	TexB.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y+fBloomPower));
	TexBR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fBloomPower,In.texCoord.y+fBloomPower));
	TexR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fBloomPower,In.texCoord.y));
	TexTR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fBloomPower,In.texCoord.y-fBloomPower));
	
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
	Out.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y));
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
	TexT.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y-fBloomPower));
	TexTL.Color = GetColorPM(float2(In.texCoord.x-fBloomPower,In.texCoord.y-fBloomPower));
	TexL.Color = GetColorPM(float2(In.texCoord.x-fBloomPower,In.texCoord.y));
	TexBL.Color = GetColorPM(float2(In.texCoord.x-fBloomPower,In.texCoord.y+fBloomPower));
	TexB.Color = GetColorPM(float2(In.texCoord.x,In.texCoord.y+fBloomPower));
	TexBR.Color = GetColorPM(float2(In.texCoord.x+fBloomPower,In.texCoord.y+fBloomPower));
	TexR.Color = GetColorPM(float2(In.texCoord.x+fBloomPower,In.texCoord.y));
	TexTR.Color = GetColorPM(float2(In.texCoord.x+fBloomPower,In.texCoord.y-fBloomPower));
	
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
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
	
    return Out;
}
