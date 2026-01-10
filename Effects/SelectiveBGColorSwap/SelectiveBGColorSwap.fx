sampler2D img; // The sprite's texture.
sampler2D bkd : register(s1); // The background's texture.

float4 RGB1; // The color you want to detect
float4 RGB2; // The color you want to replace with

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {
    // Sample the sprite's color.
    float4 spriteColor = tex2D(img,In);
    float4 o = spriteColor;
    
    // Sample the background's color.
    float4 bgColor = tex2D(bkd,In);
    
    // Check if the background color exactly matches RGB1.
    if (all(bgColor.rgb == RGB1.rgb)) {
        o = float4(RGB2.rgb, spriteColor.a); // Replace with RGB2 color.
    }
    
    // Otherwise, return the original sprite color.
    return o;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }
}