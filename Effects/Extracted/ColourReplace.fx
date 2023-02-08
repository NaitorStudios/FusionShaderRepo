
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0;
sampler2D bg : register(s1);

float3     fTint; // Replacement colour
float3     fTarget; // Target Colour
float     fTolerance; // Tolerance percent
bool fAnimation; // Switch to use animation frame as tint
bool fBlend;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	float3 RealTint;
	if (fAnimation) {
		RealTint = tex2D(Tex0, In.Texture);
	}
	else {
		RealTint.r = fTint.b;
		RealTint.g = fTint.g;
		RealTint.b = fTint.r;
	}
	Out.Color = tex2D(bg, In.Texture);
	float Difference = 1.0 - clamp(abs(Out.Color.r - fTarget.b) * 0.33333f + abs(Out.Color.g - fTarget.g) * 0.33333f + abs(Out.Color.b - fTarget.r) * 0.33333f, 0.0f, 1.0f);
	float Blending = (Difference - fTolerance) / (1.0f - fTolerance);
	if (fBlend)
		Out.Color.rgb = Difference >= fTolerance ? RealTint * Blending + Out.Color.rgb * (1.0f - Blending) : Out.Color.rgb;
	else
		Out.Color.rgb = Difference >= fTolerance ? RealTint : Out.Color.rgb;
	Out.Color.a = 1.0f;
    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}