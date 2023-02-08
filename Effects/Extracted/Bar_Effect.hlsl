// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> fImage : register(t1);
sampler fImageSampler : register(s1);


// Global variables
cbuffer PS_VARIABLES : register(b0)
{
float fValue;
};


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

// Blend coefficient

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float4 p = Demultiply(fImage.Sample(fImageSampler, In.texCoord));
    Out.Color = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint);
    float result = (p.r + p.g + p.b)/3.0;
    if( result < 1.0 - fValue){
    Out.Color.a = 0;
    }
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float4 p = Demultiply(fImage.Sample(fImageSampler, In.texCoord));
    Out.Color = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint);
    float result = (p.r + p.g + p.b)/3.0;
    if( result < 1.0 - fValue){
    Out.Color.a = 0;
    }
	Out.Color.rgb *= Out.Color.a;
    return Out;
}
