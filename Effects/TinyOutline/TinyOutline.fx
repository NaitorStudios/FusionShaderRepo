// Global variables	
sampler2D tex : register(s0);

float4 outlineColor;

float fPixelWidth;
float fPixelHeight;

float4 ps_main(float2 texCoord : TEXCOORD) : COLOR
{
    float4 c = tex2D(tex, texCoord);

    // Treat "fully transparent" with a tiny epsilon to avoid == 0.0 issues
    const float ALPHA_EPS = 1.0 / 255.0;
    float isTransparent = (c.a < ALPHA_EPS) ? 1.0 : 0.0;

    // 4-neighbor alpha max
    float aR = tex2D(tex, texCoord + float2( fPixelWidth, 0)).a;
    float aL = tex2D(tex, texCoord + float2(-fPixelWidth, 0)).a;
    float aU = tex2D(tex, texCoord + float2(0,  fPixelHeight)).a;
    float aD = tex2D(tex, texCoord + float2(0, -fPixelHeight)).a;
    float neighbor = max(max(aR, aL), max(aU, aD));

    // Consider as edge if pixel is fully transparent and neighbors a non-transparent pixel
    float edge = ((neighbor < ALPHA_EPS) ? 0.0 : 1.0) * isTransparent;

    // Apply outline color only on those edge pixels
    float3 rgb = lerp(c.rgb, outlineColor.rgb, edge);
    float  a   = max(c.a, edge);

    return float4(rgb, a);
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}