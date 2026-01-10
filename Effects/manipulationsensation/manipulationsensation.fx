sampler2D Tex0 : register(s0);
sampler2D Tex1 : register(s1);

float width, height, offsetX, offsetY, angle;
bool overlay;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0
{
    float2 centeredCoord = float2(
        (texCoord.x - 0.5) * width + 0.5 + offsetX,
        (texCoord.y - 0.5) * height + 0.5 + offsetY
    );

    float rotation = radians(angle);
    float2 offset = centeredCoord - 0.5;

    float2 rotatedCoord = float2(
        cos(rotation) * offset.x - sin(rotation) * offset.y,
        sin(rotation) * offset.x + cos(rotation) * offset.y
    );
    
    float2 finalCoord = rotatedCoord + 0.5;
    
    if (overlay)
    {
        if (finalCoord.x < 0 || finalCoord.x > 1 || finalCoord.y < 0 || finalCoord.y > 1)
        {
            discard;
        }
        
        float4 overlayColor = tex2D(Tex1, finalCoord);
        
        if (overlayColor.a == 0)
        {
            discard;
        }
        
        return overlayColor;
    }
    else
    {
        if (finalCoord.x < 0 || finalCoord.x > 1 || finalCoord.y < 0 || finalCoord.y > 1)
        {
            discard;
        }

        return tex2D(Tex0, finalCoord);
    }
}
technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); }}