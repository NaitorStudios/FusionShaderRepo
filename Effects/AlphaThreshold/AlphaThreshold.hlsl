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

// Alpha Threshold effect

cbuffer PS_VARIABLES : register(b0)
{
	float threshold;
	float smoothness;
	float opacity;
}


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}


float4 ps_main(PS_INPUT In) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample( Tex0Sampler, In.texCoord )) * In.Tint;
	
	float range = ( color.a - (1.0 - threshold) - (smoothness * 0.05) ) / (0.0001 + smoothness * 0.1) ;
	color.a = smoothstep( 0.0, 1.0, range ) ;
	
	color.a = lerp(0.0,color.a,opacity);
	return color ;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
	float4 color = Demultiply(Tex0.Sample( Tex0Sampler, In.texCoord )) * In.Tint;
	
	float range = ( color.a - (1.0 - threshold) - (smoothness * 0.05) ) / (0.0001 + smoothness * 0.1) ;
	color.a = smoothstep( 0.0, 1.0, range ) ;
	
	color.a = lerp(0.0,color.a,opacity);
	color.rgb *= color.a;
	return color;
}
