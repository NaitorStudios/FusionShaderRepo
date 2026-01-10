Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);
Texture2D<float4> Texture1 : register(t1);
sampler TextureSampler1 : register(s1);

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

cbuffer PS_VARIABLES : register(b0)
{
	float     fAlpha;
};

static const float4 colors[6] = {
        float4(0.0, 0.0, 0.0, 0.0),
        float4(0.055, 0.086, 0.102, 0.078555),
        float4(0.255, 0.357, 0.322, 0.322512),
        float4(0.565, 0.675, 0.518, 0.624212),
        float4(0.886, 0.933, 0.855, 0.910055),
        float4(1.0, 1.0, 1.0, 1.0)
    };

PS_OUTPUT ps_main(PS_INPUT In)
{
    PS_OUTPUT Out;
	
	float4 texColor = Texture0.Sample(TextureSampler0, In.texCoord);
	float4 bkdColor = Texture1.Sample(TextureSampler1, In.texCoord);
	
	// Convert color to grayscale to compare brightness
	float brightness = dot(bkdColor.rgb, float3(0.299, 0.587, 0.114));
	
	// Find next higher color
	int closestIndex = 5;
	float closest = 99.0;

    for (int i = 1; i < 6; i++) {
		float diff = colors[i].a - brightness;
		if (diff > 0.01 && diff < closest) {
			closest = diff;
			closestIndex = i;
		}
	}
    float4 nextColor = colors[closestIndex];
	nextColor.a = 1.0;
	Out.Color = nextColor * texColor * In.Tint;
	
	return Out;
}
