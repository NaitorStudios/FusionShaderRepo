Texture2D<float4> Tex0 : register(t0);
Texture2D<float4> spriteSheetTex : register(t1);
SamplerState spriteSheetTexSampler : register(s1);

cbuffer SpriteVariables : register(b0)
{
    int spriteSheetWidth;
    int spriteSheetHeight;
    int spriteWidth;
    int spriteHeight;
    int spriteColumns;
    int spriteIndex;
}

struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    float w = (float)spriteSheetWidth;
    float h = (float)spriteSheetHeight;
    
    // Normalize sprite size (0.0-1.0)
    float dx = (float)spriteWidth / w;
    float dy = (float)spriteHeight / h;

    // Figure out the number of tile cols of the sprite sheet.
    float cols = (float)spriteColumns;

    // From linear index to row/col pair.
    float col = fmod(((float)spriteIndex - 1.0), cols);
    float row = floor(((float)spriteIndex - 1.0) / cols);
    
    float2 uv = float2(col * dx + dx * In.texCoord.x, row * dy + dy * In.texCoord.y);
    
		float4 color = Demultiply(spriteSheetTex.Sample(spriteSheetTexSampler,uv));

	if (PM)
		color.rgb *= color.a;
	
	return color * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}