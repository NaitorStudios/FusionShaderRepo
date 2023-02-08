
Texture2D<float4> Tex0 : register(t0);
sampler TexSampler0 : register(s0);

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

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;

    Out.Color = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;
	float4 f4 = Out.Color * float4(0.299f, 0.587f, 0.114f, 1.0f);
	float f = f4.r + f4.g + f4.b;
	Out.Color.rgb = f;

    return Out;
}
