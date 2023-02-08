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
Texture2D<float4> oi : register(t1);
sampler oiSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float width;
	float height;
	float xoff;
	float yoff;
	float X1;
	float Y1;
	float T1;
}

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

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	float2 shiftcoor = float2(fmod((In.texCoord.x + xoff*fPixelWidth),1),fmod((In.texCoord.y + yoff*fPixelHeight),1));
	float4 shift = oi.Sample(oiSampler,shiftcoor);
	float2 off = float2(width*fPixelWidth,height*fPixelHeight);
	off.x *= 2*(shift.r-0.5);
	off.y *= 2*(shift.g-0.5);
	Out.Color = Tex0.Sample(Tex0Sampler,In.texCoord+off) * In.Tint;
	off.x *= 6*T1*(shift.r-0.5);
	off.y *= 6*T1*(shift.g-0.5);
	float dist1 = distance(float2(X1,Y1),In.texCoord+off) * 2;
	dist1 = (sin((T1/2-dist1)*(T1*16+20))*0.5+0.5) * sqrt(max(T1*0.8-dist1,0))+max(T1*0.8-dist1,0);
	Out.Color.a -= dist1;
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    PS_OUTPUT Out;
	float2 shiftcoor = float2(fmod((In.texCoord.x + xoff*fPixelWidth),1),fmod((In.texCoord.y + yoff*fPixelHeight),1));
	float4 shift = oi.Sample(oiSampler,shiftcoor);
	float2 off = float2(width*fPixelWidth,height*fPixelHeight);
	off.x *= 2*(shift.r-0.5);
	off.y *= 2*(shift.g-0.5);
	Out.Color = GetColorPM(In.texCoord+off) * In.Tint;
	off.x *= 6*T1*(shift.r-0.5);
	off.y *= 6*T1*(shift.g-0.5);
	float dist1 = distance(float2(X1,Y1),In.texCoord+off) * 2;
	dist1 = (sin((T1/2-dist1)*(T1*16+20))*0.5+0.5) * sqrt(max(T1*0.8-dist1,0))+max(T1*0.8-dist1,0);
	Out.Color.a -= dist1;
	Out.Color.rgb *= Out.Color.a;
    return Out;
}