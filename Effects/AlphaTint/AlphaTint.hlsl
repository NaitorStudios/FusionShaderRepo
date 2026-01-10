// Input structure, which represents the input for each pixel.
struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

// Sampler for the texture
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

// Shader parameters
float4 TintColor : register(c0); // The target tint color (RGB)
float Intensity : register(c1);   // The intensity of the tint (0 to 1)

// Main pixel shader function
float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    float4 Out;

    // Fetch the color of the current pixel
    float4 pixelColor = img.Sample(imgSampler, In.texCoord) * In.Tint;

    // Compute the difference between the pixel color and the TintColor
    float4 diff = TintColor - pixelColor;

    // Apply the intensity to the difference and blend with the original pixel color
    pixelColor = pixelColor + diff * Intensity;

    // Output the final color
    Out = pixelColor;

	if (PM)
		Out.rgb *= Out.a;
		
	return Out;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}