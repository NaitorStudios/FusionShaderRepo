// Pixel shader input structure
struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

// Global variables for lens distortion and rotation
Texture2D<float4> lens : register(t0);  // Object texture (used for distortion)
sampler lensSampler : register(s0);

Texture2D<float4> bg : register(t1);    // Background texture
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
    float fCoeff;   // Distortion coefficient
    float fBase;    // Base distortion value
    float fAngle;   // Rotation angle in degrees
    float fX;       // X center of rotation
    float fY;       // Y center of rotation
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

// Function to rotate texture coordinates
float2 RotateCoordinates(float2 texCoord, float centerX, float centerY, float angle)
{
    float radAngle = angle * 0.0174532925f; // Convert degrees to radians

    // Calculate distance and angle from center
    float Ray = sqrt(pow(texCoord.x - centerX, 2) + pow(texCoord.y - centerY, 2));
    float Angle;
    
    if (texCoord.y - centerY > 0)
    {
        Angle = acos((texCoord.x - centerX) / Ray);
    }
    else
    {
        Angle = -acos((texCoord.x - centerX) / Ray);
    }

    // Rotate coordinates around the center point
    float2 rotatedTexCoord;
    rotatedTexCoord.x = centerX + cos(Angle + radAngle) * Ray;
    rotatedTexCoord.y = centerY + sin(Angle + radAngle) * Ray;

    return rotatedTexCoord;
}

// Main pixel shader for rotated lens distortion
float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    // Rotate the lens (object texture) coordinates
    float2 rotatedTexCoords = RotateCoordinates(In.texCoord, fX, fY, fAngle);

    // Apply lens distortion based on the rotated coordinates
    float height = fBase + lens.Sample(lensSampler, rotatedTexCoords).r * fCoeff * In.Tint.r;
    
    In.texCoord.x += (height - 1.0f) / 2.0;
    In.texCoord.y += (height - 1.0f) / 2.0;

    // Sample the background texture using the modified coordinates
    float4 outColor =  bg.Sample(bgSampler, float2(In.texCoord.x / height, In.texCoord.y / height));
	
	if (PM)
		outColor.rgb *= outColor.a;
		
	return outColor;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}