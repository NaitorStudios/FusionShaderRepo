Texture2D<float4> Tex0: register(t0); sampler _Tex0 : register(s0);
Texture2D<float4> Tex1: register(t1); sampler _Tex1 : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
    float width, height, offsetX, offsetY, angle;
    bool overlay;
}

struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;  
};

struct PS_OUTPUT
{   
    float4 Color : SV_TARGET;   
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
    float2 centeredCoord = float2(
        (In.texCoord.x - 0.5) * width + 0.5 + offsetX,
        (In.texCoord.y - 0.5) * height + 0.5 + offsetY
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
        
        float4 overlayColor = Tex1.Sample(_Tex1,finalCoord)*In.Tint;
        
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

        return Tex0.Sample(_Tex0,finalCoord)*In.Tint;
    }
}