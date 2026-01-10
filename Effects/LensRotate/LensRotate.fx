// Global variables
sampler2D lens = sampler_state {
AddressU = border;
AddressV = border;
BorderColor = float4(0.0,0.0,0.0,0.0);
};
sampler2D bg : register(s1);
float fCoeff, fBase, fAngle, fX, fY;

// Function to rotate the texture coordinates
float2 RotateCoordinates(float2 coord, float centerX, float centerY, float angle)
{
    // Convert angle to radians
    float radAngle = angle * 0.0174532925f;

    // Calculate the distance from the center point
    float Ray = sqrt(pow(coord.x - centerX, 2) + pow(coord.y - centerY, 2));

    // Calculate the angle relative to the center
    float Angle;
    if (coord.y - centerY > 0)
        Angle = acos((coord.x - centerX) / Ray);
    else
        Angle = -acos((coord.x - centerX) / Ray);

    // Rotate the coordinates around the center
    float2 rotatedCoord;
    rotatedCoord.x = centerX + cos(Angle + radAngle) * Ray;
    rotatedCoord.y = centerY + sin(Angle + radAngle) * Ray;

    return rotatedCoord;
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
    // Rotate the lens texture (object texture)
    float2 rotatedTexCoords = RotateCoordinates(In, fX, fY, fAngle);

    // Apply lens distortion based on rotated coordinates
    float height = fBase + tex2D(lens, rotatedTexCoords).r * fCoeff;
    In.x += (height - 1.0f) / 2.0;
    In.y += (height - 1.0f) / 2.0;

    // Distort the background texture using the modified coordinates
    return tex2D(bg, float2(In.x / height, In.y / height));
}

technique tech_main
{
    pass P0
    {
        PixelShader = compile ps_2_0 ps_main();
    }
}
