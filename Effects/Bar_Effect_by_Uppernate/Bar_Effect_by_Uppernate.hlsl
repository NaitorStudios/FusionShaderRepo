// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Textures
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> fImage : register(t1);
sampler fImageSampler : register(s1);
Texture2D<float4> fBorderImage : register(t2);
sampler fBorderImageSampler : register(s2);
Texture2D<float4> fBackgroundImage : register(t3);
sampler fBackgroundImageSampler : register(s3);

// Global variables
cbuffer PS_VARIABLES : register(b0)
{
float fValue;
bool fBoolBorder;
bool fBoolBackground;
bool fBoolDraw;
};

// Blend coefficient

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float4 gradient = fImage.Sample(fImageSampler, In.texCoord) * In.Tint;
    float4 bg = fBackgroundImage.Sample(fBackgroundImageSampler, In.texCoord) * In.Tint;
    float4 border = fBorderImage.Sample(fBorderImageSampler, In.texCoord) * In.Tint;
    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
    float result = (gradient.r + gradient.g + gradient.b)/3.0;
    if( result < 1.0 - fValue){
    if( fBoolBackground == true ){
    Out.Color = bg;
    }
    else{
    Out.Color.a = 0;
    }
    }
    if( fBoolDraw == true ){
    float4 back;
    back.r = ( bg.r * bg.a * (1.0 - Out.Color.a) + Out.Color.r * Out.Color.a );
    back.g = ( bg.g * bg.a * (1.0 - Out.Color.a) + Out.Color.g * Out.Color.a );
    back.b = ( bg.b * bg.a * (1.0 - Out.Color.a) + Out.Color.b * Out.Color.a );
    back.a = (bg.a* ( 1.0 - Out.Color.a ) + Out.Color.a );
    Out.Color = back;
    }
    if( fBoolBorder == true ){
    float4 join;
    join.r = ( border.r * border.a + Out.Color.r * Out.Color.a * (1.0 - border.a) );
    join.g = ( border.g * border.a + Out.Color.g * Out.Color.a * (1.0 - border.a) );
    join.b = ( border.b * border.a + Out.Color.b * Out.Color.a * (1.0 - border.a) );
    join.a = (border.a + Out.Color.a * ( 1.0 - border.a ));
    Out.Color = join;
    }
    return Out;
}
