sampler2D img : register(s1);
// sampler2D img = sampler_state
// {
//       MinFilter = Point;
//       MagFilter = Point;
// };

// cbuffer PS_VARIABLES : register(b0)
// {
    float brightness;
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
// };

float4 closer_of_two(float3 ref, float4 a, float4 b) {
    return lerp(a, b, step(length(b.rgb-ref), length(a.rgb-ref)));
}

#define GRAY (128.0/255.0)
#define TRY(color) closest = closer_of_two(inColor, closest, color);  
//#define TRY_TRANSP(color) closest = closer_of_two(inColor, closest, float4(color.rgb, 1.0));  

// Colors are always opaque and renders 50% grey if it fails to find any better color
// The TRY macro is slightly less complex, so we can fit it in more times
// than TRY_TRANSP for passes 2 and 3

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
    float3 inColor = tex2D(img, In).rgb;
    inColor = saturate(inColor * brightness);

    float4 closest = float4(GRAY, GRAY, GRAY, 1.0);
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
    return float4(closest.rgb, 1.0);
}

technique tech_main {
	pass P1 { PixelShader  = compile ps_2_a ps_main(); }
}