struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> Overlay : register(t1);
sampler OverlaySampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float Intensity;
	int tw;
	int th;
	float xOffset;
	float yOffset;
};


cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};


float4 GetColorPM(float2 xy)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 GetColorPMOverlay(float2 xy)
{
	float4 color = Overlay.Sample(OverlaySampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main(in PS_INPUT In)
{
    PS_OUTPUT Out;
    float ratioX=  (1 / fPixelWidth) / (float)tw;
    float ratioY=  (1 / fPixelHeight) / (float)th;
    float4 testCol = GetColorPM(In.texCoord);
    Out.Color = GetColorPMOverlay(float2(fmod(In.texCoord.x * ratioX + xOffset,1),fmod(In.texCoord.y * ratioY + yOffset,1)));
    Out.Color.rgb = lerp(testCol.rgb,Out.Color.rgb,Intensity*Out.Color.a);
    Out.Color.a = testCol.a;
    Out.Color *= In.Tint;
    return Out;
}

PS_OUTPUT ps_main_pm(in PS_INPUT In)
{
    PS_OUTPUT Out;
    float ratioX=  (1 / fPixelWidth) / (float)tw;
    float ratioY=  (1 / fPixelHeight) / (float)th;
    float4 testCol = GetColorPM(In.texCoord);
    Out.Color = GetColorPMOverlay(float2(fmod(In.texCoord.x * ratioX + xOffset,1),fmod(In.texCoord.y * ratioY + yOffset,1)));
    Out.Color.rgb = lerp(testCol.rgb,Out.Color.rgb,Intensity*Out.Color.a);
    Out.Color.a = testCol.a;
    Out.Color.rgb *= Out.Color.a;
    Out.Color *= In.Tint;
    return Out;
}