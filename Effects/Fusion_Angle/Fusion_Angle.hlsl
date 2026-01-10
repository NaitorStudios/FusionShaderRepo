// Pixel shader input structure
struct PS_INPUT
{
	float4 Tint : COLOR0;
	float2 texCoord : TEXCOORD0;
	float4 Position : SV_POSITION;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
    float angle;
    float hX; // Horizontal offset in pixels
    float hY; // Vertical offset in pixels
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    // Convert angle to radians
    float angleInRadians = angle * 0.0174532925f;
    
    // Convert hX and hY from pixel units to texture coordinates
    float normalizedX = hX * fPixelWidth;
    float normalizedY = hY * fPixelHeight;
    
    // Adjust pixel coordinates to handle non-uniform aspect ratios
    float dx = (In.texCoord.x - normalizedX) / fPixelWidth;
    float dy = (In.texCoord.y - normalizedY) / fPixelHeight;

    // Calculate the radius in adjusted space
    float Ray = sqrt(dx * dx + dy * dy);
    
    // Calculate the angle from center to current pixel in adjusted space
    float Angle = atan2(dy, dx);
    
    // Apply the rotation transformation and convert back to texture space
	float2 texCoord;
    texCoord.x = normalizedX + cos(Angle + angleInRadians) * Ray * fPixelWidth;
    texCoord.y = normalizedY + sin(Angle + angleInRadians) * Ray * fPixelHeight;
    
    // Sample the texture using the adjusted texture coordinates
    float4 outColor = Tex0.Sample(Tex0Sampler, texCoord);
    
	if (PM)
		outColor.rgb *= outColor.a;
	
    // Apply the tint color
    outColor *= In.Tint;

    return outColor;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}