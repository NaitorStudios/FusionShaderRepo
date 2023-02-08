struct PS_INPUT
{
    float4 Position : POSITION;
    float2 TexCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

sampler2D sBaseTexture;
float fPixelWidth;
float fPixelHeight;
float uPixelWidth;
float uPixelHeight;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float2 dsize = float2( fPixelWidth, fPixelHeight ) * float2( uPixelWidth, uPixelHeight );
    Out.Color = tex2D( sBaseTexture, round( In.TexCoord / dsize ) * dsize );
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