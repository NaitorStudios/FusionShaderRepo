cbuffer PS_VARIABLES : register(b0)
{
    bool vert;
    float center;
    float counter;
    int dir;
    float4 color1;
    float4 color2;
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
    float2 _texCoord = In.texCoord.xy;

    float gradient= vert ? _texCoord.y/center : _texCoord.x/center;
    float4 output=lerp(color1,color2,gradient);

    if(dir==0)
    {
        output*= float4(_texCoord.x < counter, _texCoord.x < counter, _texCoord.x < counter, _texCoord.x < counter);
    }
    if(dir==1)
    {
        output*= float4(_texCoord.x > 1.0-counter, _texCoord.x > 1.0-counter, _texCoord.x > 1.0-counter, _texCoord.x > 1.0-counter);
    }
    if(dir==2)
    {
        output*= float4(_texCoord.y < counter, _texCoord.y < counter, _texCoord.y < counter, _texCoord.y < counter);
    }
    if(dir==3)
    {
        output*= float4(_texCoord.y > 1.0-counter, _texCoord.y > 1.0-counter, _texCoord.y > 1.0-counter, _texCoord.y > 1.0-counter);
    }
    return output;
}