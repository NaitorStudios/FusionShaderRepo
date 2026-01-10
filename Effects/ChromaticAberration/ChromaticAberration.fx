// 19/08/2023: Rewrote code and added intensity

sampler2D img;

float amountX;
float amountY;
float intensity;

float4 ps_main(float2 texCoord: TEXCOORD0) : COLOR {
    float2 amount = float2(amountX, amountY);

    float4 color = tex2D(img, texCoord);
    color.r = lerp(color.r, tex2D(img, texCoord + amount).r, intensity);
    color.b = lerp(color.b, tex2D(img, texCoord - amount).b, intensity);

    return color;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); }}