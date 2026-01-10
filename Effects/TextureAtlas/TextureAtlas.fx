sampler2D spriteSheetTex : register(s1) = sampler_state {MinFilter = linear; MagFilter = linear;};

// New parameters for flexible texture atlas
float spritePosX;      // X position of sprite in pixels
float spritePosY;      // Y position of sprite in pixels
float spriteWidth;     // Width of sprite in pixels
float spriteHeight;    // Height of sprite in pixels
int spriteSheetWidth;  // Width of entire texture atlas in pixels
int spriteSheetHeight; // Height of entire texture atlas in pixels

float4 ps_main(float4 color : COLOR0, in float2 input : TEXCOORD0) : COLOR0	
{
    // Calculate the normalized size of one pixel in UV space
    float pixelWidth = 1.0 / spriteSheetWidth;
    float pixelHeight = 1.0 / spriteSheetHeight;
    
    // Calculate sprite size in UV coordinates
    float spriteUVWidth = spriteWidth * pixelWidth;
    float spriteUVHeight = spriteHeight * pixelHeight;
    
    // Calculate sprite position in UV coordinates
    float spriteUVPosX = spritePosX * pixelWidth;
    float spriteUVPosY = spritePosY * pixelHeight;
    
    // Calculate UV coordinates for the current pixel
    // input.x and input.y range from 0 to 1 across the sprite quad
    float2 uv = float2(
        spriteUVPosX + (input.x * spriteUVWidth),
        spriteUVPosY + (input.y * spriteUVHeight)
    );
    
    // Sample the texture at the calculated UV coordinates
    float4 spriteColor = tex2D(spriteSheetTex, uv);
    
    // Output the color with alpha
    color.rgb = spriteColor.rgb;
    color.a = spriteColor.a;
    
    return color;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }