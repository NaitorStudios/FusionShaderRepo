#define PI 3.141569

sampler2D Tex0 : register(s0);
sampler2D Tex1 : register(s1);

float aperture;
float scale;
float fScale;
float xScale;
bool overlay;
int edgemode;
float edgeScale;

float2 fisheye(float2 xy, float d)
{
    float z = scale*sqrt(1.0-d*d*fScale);
    float r = atan2(d,z)/PI;
    r*=xScale;
    float phi = atan2(xy.y,xy.x);
    
    return r*float2(cos(phi),sin(phi))+0.5;
}


float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0
{
    float4 Out;

    float2 output = texCoord;
    float maxFactor = sin(0.5*aperture*(PI/180.0));

    float2 xy = 2.0*texCoord-1.0;
    float d = length(xy*maxFactor);
    
    //for whatever reason hlsl doesn't have switch statements
    if(edgemode==0)
    {
        output = fisheye(xy,d);
    }
    if(edgemode==2)
    {
        if(d < edgeScale * maxFactor)
            output = fisheye(xy,d);
    }
    if(edgemode==1)
    {
        if(d < edgeScale * maxFactor)
        {
            output = fisheye(xy,d);
        }else{
            output = float2(0.0,0.0);
        }
    }

    Out = overlay ? tex2D(Tex1,output) : tex2D(Tex0,output);
    return Out;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_a ps_main(); }}