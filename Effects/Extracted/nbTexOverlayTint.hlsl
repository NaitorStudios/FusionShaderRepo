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
	float4 tint;
};


cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    float4 Out;
	float2 Offset = float2(xOffset,yOffset);
    float2 ratio  = float2((1 / fPixelWidth ) / tw,
						   (1 / fPixelHeight) / th);

    float4 Color = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint);
	Out = Demultiply(Overlay.Sample(OverlaySampler, In.texCoord * ratio + Offset) * tint);
    Out.rgb = lerp(Color.rgb,Out.rgb,Intensity*Out.a);
    Out.a = Color.a;
	return Out;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    float4 Out;
	float2 Offset = float2(xOffset,yOffset);
    float2 ratio  = float2((1 / fPixelWidth ) / tw,
						   (1 / fPixelHeight) / th);
	
    float4 Color = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint);
	Out = Demultiply(Overlay.Sample(OverlaySampler, In.texCoord * ratio + Offset) * tint);
    Out.rgb = lerp(Color.rgb,Out.rgb,Intensity*Out.a);
    Out.a = Color.a;
    Out.rgb *= Out.a;
    return Out;
}