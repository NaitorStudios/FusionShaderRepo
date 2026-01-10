// Input structure, which represents the input for each pixel.
struct PS_INPUT
{
    float4 Position : POSITION;  // Pixel position
    float2 TexCoord : TEXCOORD0; // Texture coordinates
};

// Output structure, which will hold the final color of each pixel.
struct PS_OUTPUT
{
    float4 Color : COLOR0;  // The final color for the pixel
};

// Sampler for the texture
sampler2D img : register(s0);

// Shader parameters
float4 TintColor : register(c0); // The target tint color (RGB)
float Intensity : register(c1);   // The intensity of the tint (0 to 1)

// Main pixel shader function
PS_OUTPUT ps_main(PS_INPUT In)
{
    PS_OUTPUT Out;

    // Fetch the color of the current pixel
    float4 pixelColor = tex2D(img, In.TexCoord);

    // Compute the difference between the pixel color and the TintColor
    float4 diff = TintColor - pixelColor;

    // Apply the intensity to the difference and blend with the original pixel color
    pixelColor = pixelColor + diff * Intensity;

    // Output the final color
    Out.Color = pixelColor;

    return Out;
}

// Technique to apply the shader
technique tech_main
{
    pass P0
    {
        PixelShader = compile ps_1_4 ps_main();  // Using pixel shader 1.4
    }
}
