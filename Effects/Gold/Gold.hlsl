
Texture2D<float4> Tex0 : register(t0);
sampler TexSampler0 : register(s0);

Texture2D<float4> GradientTexture;
sampler GradientTextureSampler;

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


float GreyScale(float3 input) {
    float4 f4 = float4(input, 1.0f) * float4(0.299f, 0.587f, 0.114f, 1.0f);
    float f = f4.r + f4.g + f4.b;
    return f;
}
 
float3 Contrast(float3 input, float contrast) {
    return ((input - 0.5f) * max(contrast, 0)) + 0.5f;
}

float3 Brightness(float3 input, float brightness) {
    return input * float3(brightness, brightness, brightness);
}

float4 TurnGold(float3 input) {
    float mono = GreyScale(input);
    float invert = 1 - mono;
    float difference = abs(mono -  invert);
    float invert2 = 1 - difference;
    float difference2 = abs(difference - invert2);
    return GradientTexture.Sample(GradientTextureSampler, float2(difference2, 0.0f));
}


PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out =  (PS_OUTPUT)0;
    float4 inputColor = Tex0.Sample(TexSampler0, In.texCoord);
    float4 gold = TurnGold(inputColor.rgb);
    float GoldToGrey = GreyScale(gold.rgb);
    float3 greyscale = float3(GoldToGrey, GoldToGrey, GoldToGrey);
    float3 modified = lerp(greyscale, gold.rgb, 0.20).rgb;
    modified = Brightness(modified, 1.3);
    float3 final = modified * gold.rgb;
    Out.Color.rgb = final ;
    Out.Color.a = inputColor.a;
    if (inputColor.r == 0 && inputColor.g == 0 && inputColor.b == 0)
        Out.Color.a = 0;
    return Out;
}

