struct PS_INPUT
{
    float4 Position : POSITION;
    float2 TexCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

sampler2D sBaseTexture = sampler_state
{
    MipFilter = NONE;
    MinFilter = NONE;
    MagFilter = NONE;
};

sampler2D sPatternTexture : register(s1) = sampler_state
{
    MipFilter = NONE;
    MinFilter = NONE;
    MagFilter = NONE;
};
float fPixelWidth;
float fPixelHeight;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float2 size = float2( fPixelWidth, fPixelHeight );
    float2 dcoord = frac( In.TexCoord / size * float2( 0.25, 0.25 ) );
    float4 col = tex2D( sBaseTexture, In.TexCoord );
    float4 dit = tex2D( sPatternTexture, dcoord );
    float gray = dot( col.xyz, float3( 0.299, 0.587, 0.114 ) );
    float f = step( dit.x, gray );
    Out.Color = float4( f, f, f, 1.0 );
    return Out;
}

technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }
}