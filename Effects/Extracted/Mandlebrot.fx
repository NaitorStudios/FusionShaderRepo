sampler2D img;
float scale;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0
{
    float2 c,z;
    float2 center = float2(0.75,0.0);

    c.x = (16/9.0) * (texCoord.x - 0.5) * scale - center.x; 
    c.y = (texCoord.y - 0.5) * scale - center.y;

    z = c;
    int i;
    float threshold = 4;
    float j = 0;
    for(i = 0; i < 20; i++)
    {
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (z.y * z.x + z.x * z.y) + c.y;
        if (x * x + y * y > threshold)
        {
            threshold = 999999;
            j = i;
        }
        z.x = x;
        z.y = y;
    }

    texCoord.x = j / 20.0;
    texCoord.y = 0.5;
   
    return tex2D(img, texCoord);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); }}