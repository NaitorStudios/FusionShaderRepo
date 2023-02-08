struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

cbuffer PS_VARIABLES : register(b0)
{
	// Global variables
	float fPow;
	float fBleed;
}

Texture2D<float4> Tex0 : register(t1);
sampler Tex0Sampler : register(s1);

Texture2D<float4> dist_map : register(t2);
sampler dist_mapSampler : register(s2);

/*sampler2D Tex0 : register(s1) = sampler_state {
	MinFilter = None; 
	MagFilter = None; 
	MipFilter = None; 
};

sampler2D dist_map : register(s2) = sampler_state {
	MinFilter = None; 
	MagFilter = None; 
	MipFilter = None;
};*/


PS_OUTPUT ps_main(in PS_INPUT In)
{
	float distortion = dist_map.Sample(dist_mapSampler, float2(In.texCoord.x, In.texCoord.y)).r *2.0 - 1.0;
	distortion = distortion / fPow;
	float distortion2 = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x, In.texCoord.y)).g / fBleed;
	PS_OUTPUT Out;
	PS_OUTPUT distorted;
	PS_OUTPUT PXT;
	PS_OUTPUT PXTL;
	PS_OUTPUT PXL;
	PS_OUTPUT PXBL;
	PS_OUTPUT PXB;
	PS_OUTPUT PXBR;
	PS_OUTPUT PXR;
	PS_OUTPUT PXTR;
	distorted.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x + distortion, In.texCoord.y)) * 8;
	PXT.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x, In.texCoord.y - distortion2));
	PXTL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x - distortion2, In.texCoord.y - distortion2));
	PXL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x - distortion2, In.texCoord.y));
	PXBL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x - distortion2, In.texCoord.y + distortion2));
	PXB.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x, In.texCoord.y + distortion2));
	PXBR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x + distortion2, In.texCoord.y + distortion2));
	PXR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x + distortion2, In.texCoord.y));
	PXTR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x + distortion2, In.texCoord.y - distortion2));
	Out.Color = (distorted.Color + PXT.Color + PXTL.Color + PXL.Color + PXBL.Color + PXB.Color + PXBR.Color + PXR.Color + PXTR.Color) / 9;

	Out.Color *= In.Tint;
	return Out;
}

