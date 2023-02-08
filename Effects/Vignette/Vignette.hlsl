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
Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	bool bg;
	float amount;
	float4 tint;
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
    float2 tex = In.texCoord * 2 - 1;
    float dis = length(tex);
    dis = dis / 1.4142135623730950488016887242097;
    dis = pow(dis, 3);
	float4 output = float4(tint.rgb, 1.0-pow(1 - dis * amount, 2));
	float4 Color = bg ? bkd.Sample(bkdSampler,In.texCoord) : Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint);
	
	// Alpha Overlay
	float new_a = 1-(1-output.a)*(1-Color.a);
	output.rgb = (output.rgb*output.a+Color.rgb*Color.a*(1-output.a))/new_a;
	output.a = Color.a;
	
    return output;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
    float2 tex = In.texCoord * 2 - 1;
    float dis = length(tex);
    dis = dis / 1.4142135623730950488016887242097;
    dis = pow(dis, 3);
	float4 output = float4(tint.rgb, 1.0-pow(1 - dis * amount, 2));
	float4 Color = bg ? bkd.Sample(bkdSampler,In.texCoord) : Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint);
	
	// Alpha Overlay
	float new_a = 1-(1-output.a)*(1-Color.a);
	output.rgb = (output.rgb*output.a+Color.rgb*Color.a*(1-output.a))/new_a;
	output.a = Color.a;
	
	output.rgb *= output.a;
    return output;
}
