//Shader by GKInfinity

// Get image from the background
sampler2D bg : register(s1) = sampler_state{MinFilter = Point; MagFilter = Point;};

// Parameters set by user
float fScale;
float fRotationAngle;

// Rotate Function
float2 Rotate(float2 point, float angle)
{
    float pi = 3.14159265358979323846;
    float radians = angle * pi / 180;
    float s = sin(radians);
    float c = cos(radians);
    float2 rotatedPoint;
    rotatedPoint.x = point.x * c - point.y * s;
    rotatedPoint.y = point.x * s + point.y * c;
    return rotatedPoint;
}

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
    // Image center coordinates
    float2 center = float2(0.5f, 0.5f);

    // Translate the texture coordinates to the center
    float2 translatedTexCoord = In - center;

    // Rotate the texture coordinates
    float2 rotatedTexCoord = Rotate(translatedTexCoord, fRotationAngle);
	 
    // Scale the texture coordinates
    float2 scaledTexCoord = rotatedTexCoord / fScale;
	
    // Translate the texture coordinates back to the original position
    float2 finalTexCoord = scaledTexCoord + center;
		
    // Sample the color from the input texture
    float4 color = tex2D(bg, finalTexCoord);
    
    return color;
}

technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }
}