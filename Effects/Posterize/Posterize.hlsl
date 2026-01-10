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
	float fGam;
	float numColors;
};

float4 Posterize(in float4 inputColor)
{
	float3 c =inputColor.xyz;
	c = pow(abs(c), float3(fGam, fGam, fGam));
	c = floor(c * numColors);
	c = c / numColors;
	c = pow(abs(c), float3(1.0/fGam,1.0/fGam,1.0/fGam));
	
	return float4(c, inputColor.a);
}


PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = Texture0.Sample(TextureSampler0, In.texCoord) * In.Tint;
	Out.Color = Posterize(Out.Color);

    return Out;
}

float4 GetColorPM(float2 xy, float4 tint)
{
	float4 color = Texture0.Sample(TextureSampler0, xy) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = GetColorPM(In.texCoord, In.Tint);
	Out.Color = Posterize(Out.Color);
	Out.Color.rgb *= Out.Color.a;

    return Out;
}
