
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

cbuffer PS_VARIABLES : register(b0)
{
	float fCoeffX;
	float fCoeffY;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
	
	float4 c2 = Tex0.Sample(Tex0Sampler, In.texCoord.xy + float2(0,-fCoeffY)) * In.Tint;
	float4 c4 = Tex0.Sample(Tex0Sampler, In.texCoord.xy + float2(-fCoeffX,0)) * In.Tint;
	float4 c5 = Tex0.Sample(Tex0Sampler, In.texCoord.xy + float2(0,0)) * In.Tint;
	float4 c6 = Tex0.Sample(Tex0Sampler, In.texCoord.xy + float2(fCoeffX,0)) * In.Tint;
	float4 c8 = Tex0.Sample(Tex0Sampler, In.texCoord.xy + float2(0,fCoeffY)) * In.Tint;
	
	float4 c0 = (-c2-c4+c5*4-c6-c8);
	if(length(c0) < 1.0) c0 = float4(0,0,0,0);
	else c0 = float4(1,1,1,0);
	
	Out.Color.rgb = c0.rgb;
	
    return Out;
}

float4 GetColorPM(float2 xy, float4 tint)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	Out.Color = GetColorPM(In.texCoord, In.Tint);
	
	float4 c2 = GetColorPM(In.texCoord.xy + float2(0,-fCoeffY), In.Tint);
	float4 c4 = GetColorPM(In.texCoord.xy + float2(-fCoeffX,0), In.Tint);
	float4 c5 = GetColorPM(In.texCoord.xy + float2(0,0), In.Tint);
	float4 c6 = GetColorPM(In.texCoord.xy + float2(fCoeffX,0), In.Tint);
	float4 c8 = GetColorPM(In.texCoord.xy + float2(0,fCoeffY), In.Tint);
	
	float4 c0 = (-c2-c4+c5*4-c6-c8);
	if(length(c0) < 1.0) c0 = float4(0,0,0,0);
	else c0 = float4(1,1,1,0);
	
	Out.Color.rgb = c0.rgb;
	Out.Color.rgb *= Out.Color.a;
	
    return Out;
}

