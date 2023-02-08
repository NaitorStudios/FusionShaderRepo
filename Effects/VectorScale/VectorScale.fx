sampler2D Tex0;
sampler2D bkd : register(s1); 
float fBlend = 0.5;

float4 MyShader(float2 Tex : TEXCOORD0 ) : COLOR0
{
    float4 Color = tex2D(Tex0, Tex.xy);
    float4 alpha = float4(Color.rgb, smoothstep(fBlend - 0.01,fBlend + 0.01,Color.a));   //Simple anti-aliasing blend value
    float4 col = float4(0.0, 0.5, 1.0, 1.0);
    float4 shadowtexel = tex2D(Tex0, Tex.xy + float2(-0.013, 0.025));
    float4 shadow = float4(smoothstep(0.5, 0.28, shadowtexel).rgb, 1.0);
    float4 FragColor = alpha;

    return FragColor;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 MyShader();
    }

}
