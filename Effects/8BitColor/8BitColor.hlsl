struct PS_INPUT
{
    float4 Tint       : COLOR0;
    float4 Position   : POSITION;
    float2 TexCoord   : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;

    float4 rColor = Tex0.Sample(Tex0Sampler, In.TexCoord);
	
    float3 resolution = float3(8.0, 8.0, 4.0);
    rColor.rgb = floor(rColor.rgb * resolution) / (resolution - 1.0);
    
    Out.Color = rColor * In.Tint;
    return Out;
}

PS_OUTPUT ps_main_pm(in PS_INPUT In)
{
    PS_OUTPUT Out;

    float4 rColor = Tex0.Sample(Tex0Sampler, In.TexCoord);

    float3 resolution = float3(8.0, 8.0, 4.0);
    rColor.rgb = floor(rColor.rgb * resolution) / (resolution - 1.0);

    Out.Color = rColor;
    Out.Color.rgb *= Out.Color.a;
    Out.Color *= In.Tint;
    return Out;
}