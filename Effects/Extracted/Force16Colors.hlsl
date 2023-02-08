struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
    float brightness;
	bool alpha;
    float4 color1;
    float4 color2;
    float4 color3;
    float4 color4;
    float4 color5;
    float4 color6;
    float4 color7;
    float4 color8;
    float4 color9;
    float4 color10;
    float4 color11;
    float4 color12;
    float4 color13;
    float4 color14;
    float4 color15;
    float4 color16;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float3 closer_of_two(float3 ref, float3 a, float3 b) {
    return lerp(a, b, step(length(b-ref), length(a-ref)));
}

#define GRAY (128.0/255.0)
#define TRY(color) closest = closer_of_two(ref, closest, color.rgb);  

float3 closest_match(float3 ref) {  
    float3 closest = float3(GRAY, GRAY, GRAY);
    TRY(color1);
    TRY(color2);
    TRY(color3);
    TRY(color4);
    TRY(color5);
    TRY(color6);
    TRY(color7);
    TRY(color8);
    TRY(color9);
    TRY(color10);
    TRY(color11);
    TRY(color12);
    TRY(color13);
    TRY(color14);
    TRY(color15);
    TRY(color16);
    return closest;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float4 inColor = Demultiply(img.Sample(imgSampler, In.texCoord)) * In.Tint;
    float3 RGB = saturate(inColor.rgb * brightness);
	float a = alpha ? inColor.a : 1.0;
    return float4(closest_match(RGB), a);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    float4 inColor = Demultiply(img.Sample(imgSampler, In.texCoord)) * In.Tint;
    float3 RGB = saturate(inColor.rgb * brightness);
	float a = alpha ? inColor.a : 1.0;
	float4 Out = float4(closest_match(RGB), a);
	Out.rgb *= Out.a;
    return Out;
}