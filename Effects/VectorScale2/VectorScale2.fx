sampler2D Tex0;
float fBlendOutline = 0.5; // Blend threshold for outline
float fBlendFill = 0.3;    // Lower blend threshold for smoother fill
float4 outlineColor = float4(1.0, 1.0, 1.0, 1.0);  // White outline
float4 fillColor = float4(0.0, 0.0, 0.0, 1.0);     // Black fill
float2 offset = float2(0.0, 0.0); // Offset for the texture coordinates
float zoom = 1.0; // Zoom factor for the texture

float4 alpha_composite(float4 top, float4 bottom) {
    float alpha = top.a + bottom.a * (1.0 - top.a);
    return float4((top.rgb * top.a + bottom.rgb * (bottom.a * (1.0 - top.a))) / alpha, alpha);
}

float4 MyShader(float2 Tex : TEXCOORD0) : COLOR0
{
    // Adjust texture coordinates for offset and zoom
    float2 adjustedTex = (Tex - 0.5) / zoom + 0.5 + offset;
    
    float4 color = tex2D(Tex0, adjustedTex);

    // Create a discriminator for high precision outline detection
    float avgRGB = (color.r + color.g + color.b) / 3.0;
    float outlineStep = smoothstep(fBlendFill - 0.1, fBlendOutline + 0.1, avgRGB);

    // Fill transition using alpha channel
    float fillStep = smoothstep(fBlendOutline - 0.01, fBlendFill + 0.01, color.a);

    // Calculate outline and fill
    float4 outlineResult = outlineColor * outlineStep;
    float4 fillResult = fillColor;
    fillResult.a = fillStep; // Apply alpha separately to maintain color intensity

    // Combine outline and fill, let outline override the fill where it appears
    float4 result = alpha_composite(outlineResult, fillResult);
    result.rgb /= result.a; // Correct color premultiplication to maintain color intensity correctly

    return result;
}

technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 MyShader();
    }
}
