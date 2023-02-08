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

cbuffer PS_VARIABLES : register(b0)
{
	float threshold;
	float lowerclamp;
	float upperclamp;
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
	// Retrieve source pixel
	float4 front = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord)) * In.Tint;
		
	// Apply threshold
	front.a = (front.a < threshold ? lowerclamp : upperclamp);
	
	// Apply clamped alpha
	front.a = lerp(0.0,front.a,opacity);

	return front;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
	// Retrieve source pixel
	float4 front = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord)) * In.Tint;
	
	// Apply threshold
	front.a = (front.a < threshold ? lowerclamp : upperclamp);
	
	// Premultiply and apply clamped alpha
	front.a = lerp(0.0,front.a,opacity);
	front.rgb *= front.a;

	return front;
}

