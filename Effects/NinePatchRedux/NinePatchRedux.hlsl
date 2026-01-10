Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
	float xScale = 1.0;
	float yScale = 1.0;
    int repeat = 1;
}

static const float ONETHIRD = 1.0/3.0;

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 ps_main(PS_INPUT In) : SV_TARGET
{
    float chunkWidth = 1.0 / (3.0 * xScale);
    float chunkHeight = 1.0 / (3.0 * yScale);

    float2 newCoord;

    if(repeat) {
        newCoord = float2(
            ONETHIRD * fmod(In.texCoord.x - chunkWidth, chunkWidth) / chunkWidth + ONETHIRD, 
            ONETHIRD * fmod(In.texCoord.y - chunkHeight, chunkHeight) / chunkHeight + ONETHIRD);
    } else {
        newCoord = float2(
            ONETHIRD * (In.texCoord.x - chunkWidth) / (1.0 - 2.0 * chunkWidth) + ONETHIRD,
            ONETHIRD * (In.texCoord.y - chunkHeight) / (1.0 - 2.0 * chunkHeight) + ONETHIRD);
    }

    if(In.texCoord.x < chunkWidth) {
        newCoord.x = ONETHIRD * In.texCoord.x / chunkWidth;
    }
    if(In.texCoord.x > 1.0 - chunkWidth) {
        newCoord.x = ONETHIRD*(2.0 + (In.texCoord.x - 1.0 + chunkWidth) / chunkWidth);
    }
    if(In.texCoord.y < chunkHeight) {
        newCoord.y = ONETHIRD * In.texCoord.y / chunkHeight;
    }
    if(In.texCoord.y > 1.0 - chunkHeight) {
        newCoord.y = ONETHIRD*(2.0 + (In.texCoord.y - 1.0 + chunkHeight) / chunkHeight);
    }
    float4 color = Demultiply(Tex0.Sample(Tex0Sampler, newCoord));
    return color * In.Tint;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
    float chunkWidth = 1.0 / (3.0 * xScale);
    float chunkHeight = 1.0 / (3.0 * yScale);

    float2 newCoord;

    if(repeat) {
        newCoord = float2(
            ONETHIRD * fmod(In.texCoord.x - chunkWidth, chunkWidth) / chunkWidth + ONETHIRD, 
            ONETHIRD * fmod(In.texCoord.y - chunkHeight, chunkHeight) / chunkHeight + ONETHIRD);
    } else {
        newCoord = float2(
            ONETHIRD * (In.texCoord.x - chunkWidth) / (1.0 - 2.0 * chunkWidth) + ONETHIRD,
            ONETHIRD * (In.texCoord.y - chunkHeight) / (1.0 - 2.0 * chunkHeight) + ONETHIRD);
    }

    if(In.texCoord.x < chunkWidth) {
        newCoord.x = ONETHIRD * In.texCoord.x / chunkWidth;
    }
    if(In.texCoord.x > 1.0 - chunkWidth) {
        newCoord.x = ONETHIRD*(2.0 + (In.texCoord.x - 1.0 + chunkWidth) / chunkWidth);
    }
    if(In.texCoord.y < chunkHeight) {
        newCoord.y = ONETHIRD * In.texCoord.y / chunkHeight;
    }
    if(In.texCoord.y > 1.0 - chunkHeight) {
        newCoord.y = ONETHIRD*(2.0 + (In.texCoord.y - 1.0 + chunkHeight) / chunkHeight);
    }
    float4 color = Tex0.Sample(Tex0Sampler, newCoord);
    return color * In.Tint;
}