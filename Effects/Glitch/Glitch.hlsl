
cbuffer PS_VARIABLES : register(b0)
{
	float fPow;
	float fBleed;
};

Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

Texture2D<float4> dist_map : register(t1);
sampler dist_mapSampler : register(s1);

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

PS_OUTPUT ps_main(in PS_INPUT In)
{
	float distortion = dist_map.Sample(dist_mapSampler, In.texCoord).r *2.0 - 1.0;
	distortion = distortion / fPow;
	float distortion2 = Texture0.Sample(TextureSampler0, In.texCoord).g  * In.Tint.g / fBleed;
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
	distorted.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion, In.texCoord.y)) * 8;
	PXT.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x, In.texCoord.y - distortion2));
	PXTL.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x - distortion2, In.texCoord.y - distortion2));
	PXL.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x - distortion2, In.texCoord.y));
	PXBL.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x - distortion2, In.texCoord.y + distortion2));
	PXB.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x, In.texCoord.y + distortion2));
	PXBR.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion2, In.texCoord.y + distortion2));
	PXR.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion2, In.texCoord.y));
	PXTR.Color = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion2, In.texCoord.y - distortion2));
	Out.Color = (distorted.Color + PXT.Color + PXTL.Color + PXL.Color + PXBL.Color + PXB.Color + PXBR.Color + PXR.Color + PXTR.Color) / 9;

	Out.Color = Out.Color * In.Tint;

	return Out;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 cr = dist_map.Sample(dist_mapSampler, In.texCoord);
	if ( cr.a != 0 )
		cr.r /= cr.a;
	float distortion = cr.r * 2.0 - 1.0;
	distortion = distortion / fPow;
	
	float4 cr2 = Texture0.Sample(TextureSampler0, In.texCoord) * In.Tint;
	if ( cr2.a != 0 )
		cr2.g /= cr2.a;
	float distortion2 = cr2.g / fBleed;

	float4 distorted = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion, In.texCoord.y)) * In.Tint * 8;
	float4 PXT = Texture0.Sample(TextureSampler0, float2(In.texCoord.x, In.texCoord.y - distortion2)) * In.Tint;
	float4 PXTL = Texture0.Sample(TextureSampler0, float2(In.texCoord.x - distortion2, In.texCoord.y - distortion2)) * In.Tint;
	float4 PXL = Texture0.Sample(TextureSampler0, float2(In.texCoord.x - distortion2, In.texCoord.y)) * In.Tint;
	float4 PXBL = Texture0.Sample(TextureSampler0, float2(In.texCoord.x - distortion2, In.texCoord.y + distortion2)) * In.Tint;
	float4 PXB = Texture0.Sample(TextureSampler0, float2(In.texCoord.x, In.texCoord.y + distortion2)) * In.Tint;
	float4 PXBR = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion2, In.texCoord.y + distortion2)) * In.Tint;
	float4 PXR = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion2, In.texCoord.y)) * In.Tint;
	float4 PXTR = Texture0.Sample(TextureSampler0, float2(In.texCoord.x + distortion2, In.texCoord.y - distortion2)) * In.Tint;
	if ( distorted.a != 0 )
		distorted.rgb /= distorted.a;
	if ( PXT.a != 0 )
		PXT.rgb /= PXT.a;
	if ( PXTL.a != 0 )
		PXTL.rgb /= PXTL.a;
	if ( PXL.a != 0 )
		PXL.rgb /= PXL.a;
	if ( PXBL.a != 0 )
		PXBL.rgb /= PXBL.a;
	if ( PXB.a != 0 )
		PXB.rgb /= PXB.a;
	if ( PXBR.a != 0 )
		PXBR.rgb /= PXBR.a;
	if ( PXR.a != 0 )
		PXR.rgb /= PXR.a;
	if ( PXTR.a != 0 )
		PXTR.rgb /= PXTR.a;

	float4 Out = (distorted + PXT + PXTL + PXL + PXBL + PXB + PXBR + PXR + PXTR) / 9;
	Out.rgb *= Out.a;

	return Out;
}

