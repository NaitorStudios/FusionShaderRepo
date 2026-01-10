//Shader by GKInfinity

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Get image from the background
Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

// Parameters set by user
float fScale;
float fRotationAngle;

// Rotate Function
float2 Rotate(float2 _point, float _angle)
{
    float pi = 3.14159265358979323846;
    float radians = _angle * pi / 180;
    float s = sin(radians);
    float c = cos(radians);
    float2 rotatedPoint;
    rotatedPoint.x = _point.x * c - _point.y * s;
    rotatedPoint.y = _point.x * s + _point.y * c;
    return rotatedPoint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    // Image center coordinates
    float2 center = float2(0.5f, 0.5f);

    // Translate the texture coordinates to the center
    float2 translatedTexCoord = In.texCoord - center;

    // Rotate the texture coordinates
    float2 rotatedTexCoord = Rotate(translatedTexCoord, fRotationAngle);
	 
    // Scale the texture coordinates
    float2 scaledTexCoord = rotatedTexCoord / fScale;
	
    // Translate the texture coordinates back to the original position
    float2 finalTexCoord = scaledTexCoord + center;
		
    // Sample the color from the input texture
    float4 color = bg.Sample(bgSampler, finalTexCoord);
    
    return color;
}
