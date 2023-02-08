
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fAngle;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	In.texCoord.x = In.texCoord.x-0.5;
	In.texCoord.y = In.texCoord.y-0.5;
	float radAngle =  radians(fAngle);
	float Tcos = cos(radAngle);
	float Tsin = sin(radAngle);
	float Temp = In.texCoord.x * Tcos - In.texCoord.y * Tsin + 0.5;
	In.texCoord.y = In.texCoord.y * Tcos + In.texCoord.x * Tsin + 0.5;
	In.texCoord.x = Temp;
	
    return Tex0.Sample(Tex0Sampler, In.texCoord.xy);
}

