
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color : SV_TARGET;
};

// Global variables
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fGlowPower;
	float fGlowStrenght;
	float4 fGlowColor;
	float fContrast;
};


PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,In.texCoord.y));
	float4 fOldColor;
	float4 fBlurColor;
	
	//fContrast=0.0f-fContrast;
	//fGlowPower=fGlowPower*fGlowStrenght;
	float fGlowStrenght2=fGlowStrenght+0.5f;
	
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
	TexT.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,In.texCoord.y-fGlowPower));
	TexTL.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x-fGlowPower,In.texCoord.y-fGlowPower));
	TexL.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x-fGlowPower,In.texCoord.y));
	TexBL.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x-fGlowPower,In.texCoord.y+fGlowPower));
	TexB.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,In.texCoord.y+fGlowPower));
	TexBR.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x+fGlowPower,In.texCoord.y+fGlowPower));
	TexR.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x+fGlowPower,In.texCoord.y));
	TexTR.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x+fGlowPower,In.texCoord.y-fGlowPower));
	
	fBlurColor = (Out.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/9;
	
	Out.Color.a=fBlurColor.a+fOldColor.a;
	Out.Color.rgb=fOldColor.rgb/2+fBlurColor.rgb*fGlowStrenght2;
	
	if(fOldColor.a<1.0f && fGlowPower>0.0f)
	{
		Out.Color.a=fBlurColor.a+fOldColor.a;
		Out.Color.rgb=fGlowColor.rgb*fGlowPower*100.0f*(1.0f-fOldColor.a)+fOldColor.rgb*(fOldColor.a);
	}
	else if(fOldColor.a<1.0f)
	{
		Out.Color.a=fOldColor.a;
	}
	Out.Color = Out.Color * In.Tint;
	
    return Out;
}

float4 GetColor0(float x, float y)
{
	float4 color = Texture0.Sample(TextureSampler0, float2(x,y));
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = GetColor0(In.texCoord.x,In.texCoord.y);
	float4 fOldColor;
	float4 fBlurColor;
	
	float fGlowStrenght2=fGlowStrenght+0.5f;
	
	Out.Color.rgb = Out.Color.rgb*(1.0f+fContrast);
	
	fOldColor=Out.Color;

	float4 TexT = GetColor0(In.texCoord.x,In.texCoord.y-fGlowPower);
	float4 TexTL = GetColor0(In.texCoord.x-fGlowPower,In.texCoord.y-fGlowPower);
	float4 TexL = GetColor0(In.texCoord.x-fGlowPower,In.texCoord.y);
	float4 TexBL = GetColor0(In.texCoord.x-fGlowPower,In.texCoord.y+fGlowPower);
	float4 TexB = GetColor0(In.texCoord.x,In.texCoord.y+fGlowPower);
	float4 TexBR = GetColor0(In.texCoord.x+fGlowPower,In.texCoord.y+fGlowPower);
	float4 TexR = GetColor0(In.texCoord.x+fGlowPower,In.texCoord.y);
	float4 TexTR = GetColor0(In.texCoord.x+fGlowPower,In.texCoord.y-fGlowPower);
	
	fBlurColor = (Out.Color+TexT+TexTL+TexL+TexBL+TexB+TexBR+TexR+TexTR)/9;

	Out.Color.a=fBlurColor.a+fOldColor.a;
	Out.Color.rgb=fOldColor.rgb/2+fBlurColor.rgb*fGlowStrenght2;
	
	if(fOldColor.a<1.0f && fGlowPower>0.0f)
	{
		Out.Color.a=fBlurColor.a+fOldColor.a;
		Out.Color.rgb=fGlowColor.rgb*fGlowPower*100.0f*(1.0f-fOldColor.a)+fOldColor.rgb*(fOldColor.a);
	}
	else if(fOldColor.a<1.0f)
	{
		Out.Color.a=fOldColor.a;
	}
	
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
	
    return Out;
}
