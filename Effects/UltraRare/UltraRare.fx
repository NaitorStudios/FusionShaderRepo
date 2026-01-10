// UltraRare.fx - Directional shimmer using angleX and angleY
// angleX = horizontal shimmer bias
// angleY = vertical shimmer bias
// thickness = foil stripe frequency
// time = shimmer animation time

sampler2D sampler0 : register(s0);
float angleX;      // Range: -2.0 to 2.0
float angleY;      // Range: -2.0 to 2.0
float time;        // 0.0+
float thickness;   // Range: 5.0 to 100.0

float4 main(float2 uv : TEXCOORD0) : COLOR {
    float shimmer = abs(sin((uv.x * angleX + uv.y * angleY) * thickness + time)) * 0.3;

    float4 tex = tex2D(sampler0, uv);
    float3 goldTint = float3(1.0, 0.85, 0.5);
    tex.rgb *= goldTint;
    return tex + float4(shimmer, shimmer * 0.8, shimmer * 0.2, 0);
}

technique DefaultTechnique {
    pass P0 {
        PixelShader = compile ps_2_0 main();
    }
}