#define PI 3.141569

Texture2D<float4> Tex0: register(t0); sampler _Tex0 : register(s0);
Texture2D<float4> Tex1: register(t1); sampler _Tex1 : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
    float radius;
    float angle;
    float offsetX;
    float offsetY;
    float width;
    float height;
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
    float2 output;

    float2 offset = float2(offsetX,offsetY);
    float2 size = float2(width,height);

    float2 uv = In.texCoord.xy - offset;

    float len = length(uv/size);
    float _angle = atan2(uv.y,uv.x)+ (angle*PI) * smoothstep(radius,0.0,len);
    float _radius = length(uv);

    output = float2(_radius*cos(_angle),_radius*sin(_angle))+offset;

    float4 Out = overlay ? Tex1.Sample(_Tex1,output)*In.Tint : Tex0.Sample(_Tex0,output)*In.Tint;
    return Out;
}