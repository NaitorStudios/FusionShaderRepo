
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

// Texture(s)
Texture2D<float4> Texture : register(t0);
sampler TextureSampler : register(s0);

// Parameters
cbuffer PS_VARIABLES : register(b0)
{
	float fBrightness;
	float fContrast;
};

// Non-premultiplied shader
PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	
	Out.Color = Texture.Sample(TextureSampler, In.texCoord.xy);
    Out.Color.rgb = Out.Color.rgb * fContrast + (fBrightness/256);
	Out.Color = Out.Color * In.Tint;
    return Out;
}

// Premultiplied shader
PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    PS_OUTPUT Out;
	
	Out.Color = Texture.Sample(TextureSampler, In.texCoord.xy);
    Out.Color.rgb = Out.Color.rgb * fContrast + (fBrightness/256) * Out.Color.a;
	Out.Color = Out.Color * In.Tint;
    return Out;
}
