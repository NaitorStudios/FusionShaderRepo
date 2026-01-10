
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);
Texture2D<float4> mask : register(t2);
sampler maskSampler : register(s2);

cbuffer PS_VARIABLES : register(b0)
{
	float fCoeff;
	float fBlend;
	int Mode;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    float maskValue;
    float2 maskCoord = In.texCoord;

    // Adjust coordinates for mask application based on mode
    if (Mode == 1) {
        if (In.texCoord.y < fCoeff) {
            In.texCoord.y = (-In.texCoord.y / fCoeff) + In.texCoord.y + 1;
        }
        maskCoord.y = (In.texCoord.y < 0.5) ? 2.0 * In.texCoord.y : 2.0 * (1.0 - In.texCoord.y);  // Reflect vertically from middle
    }
    else if (Mode == 2) {
        if (In.texCoord.x < fCoeff) {
            In.texCoord.x = (-In.texCoord.x / fCoeff) + In.texCoord.x + 1;
        }
        maskCoord.x = (In.texCoord.x < 0.5) ? 2.0 * In.texCoord.x : 2.0 * (1.0 - In.texCoord.x);  // Reflect horizontally from middle
    }
    else if (Mode == 3) {
        if (In.texCoord.x > fCoeff) {
            In.texCoord.x = ((In.texCoord.x - 1) * fCoeff) / (fCoeff - 1);
        }
        maskCoord.x = (In.texCoord.x > 0.5) ? 2.0 * (In.texCoord.x - 0.5) : 2.0 * (0.5 - In.texCoord.x);  // Reflect horizontally from middle
    }
    else {  // Mode 0 by default
        if (In.texCoord.y > fCoeff) {
            In.texCoord.y = ((In.texCoord.y - 1) * fCoeff) / (fCoeff - 1);
        }
        maskCoord.y = (In.texCoord.y > 0.5) ? 2.0 * (In.texCoord.y - 0.5) : 2.0 * (0.5 - In.texCoord.y);  // Reflect vertically from middle
    }

    maskValue = mask.Sample(maskSampler, maskCoord).r;  // Sample mask texture using modified coordinates
    float4 bgColor = bg.Sample(bgSampler, In.texCoord);
    float4 outColor = float4(bgColor.rgb, (1.0 - fBlend) * maskValue) * In.Tint;  // Apply mask to alpha or reflection
	
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