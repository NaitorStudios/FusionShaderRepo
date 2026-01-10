sampler2D Tex0;

float fL;
float fR;
float fT;
float fB;

struct PS_INPUT
{
    float2 Texture : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    Out.Color = tex2D(Tex0, In.Texture);
    
    // Make the defined rectangle transparent
    if(In.Texture.x > fL && In.Texture.x < 1.0f - fR && In.Texture.y > fT && In.Texture.y < 1.0f - fB)
    {
        Out.Color.a = 0.0f;
    }
    
    return Out;
}

technique tech_main
{
    pass P0
    {
        PixelShader = compile ps_2_0 ps_main();
    }  
}
