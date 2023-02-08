
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
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fCoeff;
	float fAngle;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	float Dist = distance(In.texCoord.xy, float2(0.5,0.5)) * 2;
	if (Dist < 1.0){
		float Angle = atan2(In.texCoord.y - 0.5, In.texCoord.x - 0.5) + pow(1 - Dist,2) * fAngle;
		Dist = (pow(Dist,fCoeff)) / 2;
		In.texCoord.x = cos(Angle) * Dist + 0.5;
		In.texCoord.y = sin(Angle) * Dist + 0.5;
	}
   	Out.Color = Texture0.Sample(TextureSampler0, In.texCoord.xy);
	Out.Color = Out.Color * In.Tint;
	
    return Out;
}
