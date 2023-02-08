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
Texture2D<float4> fg : register(t0);
sampler fgSampler : register(s0);
Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float R;
	float G;
	float B;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}


float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 src = Demultiply(fg.Sample(fgSampler,In.texCoord) * In.Tint);
	float3 inv = src.rgb;
	float4 bck = Demultiply(bg.Sample(bgSampler,In.texCoord));
	if(bck.r==R/255 && bck.g==G/255 && bck.b==B/255 )
	{
			bck=src;
	}
	return bck;
}
