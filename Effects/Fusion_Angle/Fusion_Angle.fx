// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0 = sampler_state {
    AddressU = border;
    AddressV = border;
    BorderColor = float4(1.0, 1.0, 1.0, 0.0);
};

float angle;
float hX; // Horizontal offset in pixels
float hY; // Vertical offset in pixels
float fPixelWidth; // Width of one pixel in the texture
float fPixelHeight; // Height of one pixel in the texture

PS_OUTPUT ps_main(in PS_INPUT In)
{
    // Output pixel
    PS_OUTPUT Out;
    
    // Convert angle to radians
    float angleInRadians = angle * 0.0174532925f;
    
    // Convert hX and hY from pixel units to texture coordinates
    float normalizedX = hX * fPixelWidth;
    float normalizedY = hY * fPixelHeight;
    
    // Adjust pixel coordinates to handle non-uniform aspect ratios
    float dx = (In.Texture.x - normalizedX) / fPixelWidth;
    float dy = (In.Texture.y - normalizedY) / fPixelHeight;

    // Calculate the radius in adjusted space
    float Ray = sqrt(dx * dx + dy * dy);
    
    // Calculate the angle from center to current pixel in adjusted space
    float Angle = atan2(dy, dx);
    
    // Apply the rotation transformation and convert back to texture space
    In.Texture.x = normalizedX + cos(Angle + angleInRadians) * Ray * fPixelWidth;
    In.Texture.y = normalizedY + sin(Angle + angleInRadians) * Ray * fPixelHeight;
    
    // Fetch the color from the modified texture coordinates
    Out.Color = tex2D(Tex0, In.Texture.xy);
    
    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader = compile ps_2_0 ps_main();
    }  
}
