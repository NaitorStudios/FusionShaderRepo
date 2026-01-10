// Texture2D<float4> mainTexute : register(t0);
// SamplerState mainTexuteSampler : register(s0);

Texture2D<float4> spriteSheet : register(t1);
SamplerState spriteSheetSampler : register(s1);

cbuffer SpriteVariables : register(b0)
{
Texture2D spriteSheetTex;
int spriteSheetWidth;
int spriteSheetHeight;
int spriteWidth;
int spriteHeight;
int spritePosX;
int spritePosY;
int spriteIndex;
}

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

float4 Demultiply(float4 _color)
{
    float4 color = _color;
    if ( color.a != 0 )
        color.rgb /= color.a;
    return color;
}

float4 effect(float2 In, float4 Tint, bool PM ) : SV_TARGET
{
    // Calculate the normalized size of one pixel in UV space
    float pixelWidth = 1.0 / (float)spriteSheetWidth;
    float pixelHeight = 1.0 / (float)spriteSheetHeight;
    
    // Calculate sprite size in UV coordinates
    float spriteUVWidth = (float)spriteWidth * pixelWidth;
    float spriteUVHeight = (float)spriteHeight * pixelHeight;
    
    // Calculate sprite position in UV coordinates
    float spriteUVPosX = (float)spritePosX * pixelWidth;
    float spriteUVPosY = (float)spritePosY * pixelHeight;
    
    // Calculate UV coordinates for the current pixel
    // input.x and input.y range from 0 to 1 across the sprite quad
    float2 uv = float2(
        spriteUVPosX + (In.x * spriteUVWidth),
        spriteUVPosY + (In.y * spriteUVHeight)
    );
    
    float4 color = Demultiply(spriteSheet.Sample(spriteSheetSampler, uv));

    if (PM)
        color.rgb *= color.a;
        
    return color;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    Out.Color = effect(In.texCoord, In.Tint, false);
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In ) 
{
    PS_OUTPUT Out;
    Out.Color = effect(In.texCoord, In.Tint, true);
    return Out;
}