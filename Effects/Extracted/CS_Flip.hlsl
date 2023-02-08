
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
	int iFlipX;
	int iFlipY;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	if(iFlipX==0 && iFlipY==0)
	{
		Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,In.texCoord.y));
	}
	else if(iFlipX==1 && iFlipY==0)
	{
		Out.Color = Tex0.Sample(Tex0Sampler, float2(1.0-In.texCoord.x,In.texCoord.y));
	}
	else if(iFlipX==0 && iFlipY==1)
	{
		Out.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x,1.0-In.texCoord.y));
	}
	else
	{
		Out.Color = Tex0.Sample(Tex0Sampler, float2(1.0-In.texCoord.x,1.0-In.texCoord.y));
	}
	Out.Color *= In.Tint;
	
    return Out;
}

