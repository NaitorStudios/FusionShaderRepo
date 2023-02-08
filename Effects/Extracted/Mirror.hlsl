
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
	int iM;
	int iS;
	float fB;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
        Out.Color = Tex0.Sample(Tex0Sampler,In.texCoord.xy);
        //Mirror X
        if(iM==0) {
	if(iS==0 && In.texCoord.x > fB)
         Out.Color = Tex0.Sample(Tex0Sampler, float2(fB-(In.texCoord.x-fB),In.texCoord.y));
	else
	 if(iS==1 && In.texCoord.x < fB) Out.Color = Tex0.Sample(Tex0Sampler, float2(fB-(In.texCoord.x-fB),In.texCoord.y));
        }
        //Mirror Y
        if(iM==1) {
	if(iS==0 && In.texCoord.y > fB)
         Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,fB-(In.texCoord.y-fB)));
	else
	 if(iS==1 && In.texCoord.y < fB) Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,fB-(In.texCoord.y-fB)));
        }
	Out.Color *= In.Tint;
    return Out;
}
