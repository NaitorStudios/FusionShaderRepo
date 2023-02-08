struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

sampler2D sBaseTexture;
float uInvTexelWidth;
float uInvTexelHeight;
float uPhase;
float uScale;
float uBorderTreshold;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float2 phs = float2( cos( uPhase + ( In.Texture.y * uScale ) ), sin( uPhase + ( In.Texture.x * uScale ) ) );
    float2 crd = In.Texture + ( phs * float2( uInvTexelWidth, uInvTexelHeight ) );
    float2 btr = float2( uInvTexelWidth * 5.0, uInvTexelHeight * 5.0 );
    Out.Color = tex2D( sBaseTexture, clamp( crd, btr, float2( 1.0, 1.0 ) - btr ) );
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