
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
Texture2D<float4> Texture : register(t0);
sampler TextureSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float h1;
	float h2;
	float c1;
	float c2;
	float t1;
	float t2;
	float l1;
	float l2;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
	PS_OUTPUT Out;
	Out.Color = float4(1,0,0,1);
	
	float ch = (h1 + (h2 - h1) * In.texCoord.x) / 2;
	float cc = c1 + (c2 - c1) * In.texCoord.x;
	float cl = l1 + (l2 - l1) * In.texCoord.x;
	
	if(In.texCoord.y < cc - ch || In.texCoord.y > cc + ch) //<<<<<<<<<<<< = ps_2_0
	{
		Out.Color = float4(0,0,0,0);
	}
	else
	{
		float cy = (In.texCoord.y - cc + ch) / (ch*2);
		float cx = In.texCoord.x * (t2 - t1) + t1;
		Out.Color = Texture.Sample(TextureSampler, float2(cx,cy));
		Out.Color *= float4(cl,cl,cl,1);
	}
	Out.Color *= In.Tint;
	return Out;
}
