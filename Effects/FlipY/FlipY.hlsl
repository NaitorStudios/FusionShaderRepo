
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

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

PS_OUTPUT ps_main(PS_INPUT In)
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x,1.0-In.texCoord.y)) * In.Tint;
    return Out;
}
