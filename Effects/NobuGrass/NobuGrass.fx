sampler2D Tex0;
sampler2D Grass : register(s1);  //Our extra texture 

float fBlend = 1.0;  //Simple Parameter

float4 MyShader( float2 Tex : TEXCOORD0 ) : COLOR0
{
    float4 Color;
    float4 GrassColor;
    
    Color = tex2D( Tex0, Tex.xy);
    GrassColor = tex2D( Grass, Tex.xy );
    Color.a = Color.a * (1.0f - GrassColor.g*fBlend);

    return Color;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 MyShader();
    }

}
