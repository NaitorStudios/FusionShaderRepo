struct PS_INPUT
{
    float4 Position : POSITION;
    float2 Texture : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

float  fWidth;
float fHeight;
float fBorder;
float4 fColor;
float fStepThreshold =  .5;
float defPixSize     = 1.;

sampler2D img;
sampler2D bkd : register(s1); // bind :: Sampler

PS_OUTPUT ps_main( in PS_INPUT In )
{
    float pixelSizeX = defPixSize / fWidth;
    float pixelSizeY = defPixSize / fHeight;
    float pixelX     = step(abs(fStepThreshold - In.Texture.x), fStepThreshold - pixelSizeX * fBorder);
    float pixelY     = step(abs(fStepThreshold - In.Texture.y), fStepThreshold - pixelSizeY * fBorder);
    float pixelR     = pixelX * pixelY;
    float4 colorR    = float4( fColor.rgb, 1 );
    PS_OUTPUT Out;
    if (pixelR > fStepThreshold) {
        Out.Color = tex2D(bkd, In.Texture) * tex2D(img, In.Texture);
    }else{
        Out.Color = colorR;
    }
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