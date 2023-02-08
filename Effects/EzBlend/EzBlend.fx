sampler2D Tex0;
sampler2D Blend : register(s2); 
sampler2D bkd : register(s1); 

float Intensity = 1.0;

float4 MyShader(float2 Tex : TEXCOORD0 ) : COLOR0
{
    float4 bgColor;
    float4 Color;
    float4 blendColor;
    float4 output = 1;
    
    bgColor = tex2D( bkd, Tex.xy);
    Color = tex2D( Tex0, Tex.xy);

    output.a = Color.a;

    blendColor = tex2D ( Blend, float2 (min(0.999, bgColor.r), min(0.999,Color.r)) );
    output.r = blendColor.r;
    blendColor = tex2D ( Blend, float2 (min(0.999, bgColor.g), min(0.999,Color.g)) );
    output.g = blendColor.g;
    blendColor = tex2D ( Blend, float2 (min(0.999, bgColor.b), min(0.999,Color.b)) );
    output.b = blendColor.b;

    output.rgb = lerp(Color.rgb, output.rgb, Intensity);

    return output;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 MyShader();
    }

}
