
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
	float4 fGlowColor;
	float fContrast;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,In.texCoord.y));
	float4 fOldColor = Out.Color;
	float fInvContrast = 0-fContrast;
	
	Out.Color.rgb = Out.Color.rgb*(1.0f-fInvContrast)+(1.0f-Out.Color.rgb)*fInvContrast;
	if(Out.Color.a<1.0f)
	{
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
		
		Out.Color = (Out.Color+TexT.Color+TexTL.Color+TexL.Color+TexBL.Color+TexB.Color+TexBR.Color+TexR.Color+TexTR.Color)/9;
		Out.Color.a=Out.Color.a+fOldColor.a;
		Out.Color.rgb=fGlowColor.rgb*(1.0f-fOldColor.a)+fOldColor.rgb*(fOldColor.a);
	}
	Out.Color = Out.Color * In.Tint;
	
    return Out;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    // Output pixel
    float4 Out = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,In.texCoord.y));
	if ( Out.a != 0 )
		Out.rgb /= Out.a;
	float4 fOldColor = Out;
	float fInvContrast = 0-fContrast;
	
	Out.rgb = Out.rgb*(1.0f-fInvContrast)+(1.0f-Out.rgb)*fInvContrast;
	if(Out.a<1.0f)
	{
		float4 TexT = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,In.texCoord.y-fGlowPower));
		float4 TexTL = Texture0.Sample(TextureSampler0, float2(In.texCoord.x-fGlowPower,In.texCoord.y-fGlowPower));
		float4 TexL = Texture0.Sample(TextureSampler0, float2(In.texCoord.x-fGlowPower,In.texCoord.y));
		float4 TexBL = Texture0.Sample(TextureSampler0, float2(In.texCoord.x-fGlowPower,In.texCoord.y+fGlowPower));
		float4 TexB = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,In.texCoord.y+fGlowPower));
		float4 TexBR = Texture0.Sample(TextureSampler0, float2(In.texCoord.x+fGlowPower,In.texCoord.y+fGlowPower));
		float4 TexR = Texture0.Sample(TextureSampler0, float2(In.texCoord.x+fGlowPower,In.texCoord.y));
		float4 TexTR = Texture0.Sample(TextureSampler0, float2(In.texCoord.x+fGlowPower,In.texCoord.y-fGlowPower));
		if ( TexT.a != 0 )
			TexT.rgb /= TexT.a;
		if ( TexTL.a != 0 )
			TexTL.rgb /= TexTL.a;
		if ( TexL.a != 0 )
			TexL.rgb /= TexL.a;
		if ( TexBL.a != 0 )
			TexBL.rgb /= TexBL.a;
		if ( TexB.a != 0 )
			TexB.rgb /= TexB.a;
		if ( TexBR.a != 0 )
			TexBR.rgb /= TexBR.a;
		if ( TexR.a != 0 )
			TexR.rgb /= TexR.a;
		if ( TexTR.a != 0 )
			TexTR.rgb /= TexTR.a;
		Out = (Out+TexT+TexTL+TexL+TexBL+TexB+TexBR+TexR+TexTR)/9;
		Out.a = Out.a+fOldColor.a;
		Out.rgb=fGlowColor.rgb*(1.0f-fOldColor.a)+fOldColor.rgb*(fOldColor.a);
	}
	Out.rgb *= Out.a;
	Out = Out * In.Tint;
    return Out;
}
