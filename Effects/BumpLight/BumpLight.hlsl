struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

Texture2D<float4> bumpmap : register(t1);
sampler bumpmapSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float light_x;
	float light_y;
	float4 LightColor;	// = {0.5,1,1};
	float AmbientColor;
};

// ----------------------------------------------------------------------------
// PIXEL SHADER
// ----------------------------------------------------------------------------

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float3 LightDir = normalize(float3(light_x,light_y,1));

	float4 specColor = float4(0.1,0.1,0.1,0.1);
	float3 amb = { AmbientColor, AmbientColor, AmbientColor};

	float4 maintexture = Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint;
	float4 normalmap = 2*bumpmap.Sample(bumpmapSampler,In.texCoord)-1.0;
	float lightamt = max(dot(normalmap.xyz,LightDir),0.0);

	float4  color;
	color.rgb = maintexture.rgb *( amb + ( lightamt * LightColor.rgb));

	color.a = maintexture.a;
	return color;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float3 LightDir = normalize(float3(light_x,light_y,1));

	float4 specColor = float4(0.1,0.1,0.1,0.1);
	float3 amb = { AmbientColor, AmbientColor, AmbientColor};

	float4 maintexture = Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint;
	if ( maintexture.a != 0 )
		maintexture.rgb /= maintexture.a;
	float4 normalmap = 2*bumpmap.Sample(bumpmapSampler,In.texCoord)-1.0;
	if ( normalmap.a != 0 )
		normalmap.rgb /= normalmap.a;
	float lightamt = max(dot(normalmap.xyz,LightDir),0.0);

	float4  color;
	color.rgb = maintexture.rgb *( amb + ( lightamt * LightColor.rgb));

	color.a = maintexture.a;
	color.rgb *= color.a;

	return color;
}
