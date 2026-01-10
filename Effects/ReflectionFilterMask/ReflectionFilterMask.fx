sampler2D bg : register(s1);
sampler2D mask : register(s2);  // Mask texture sampler
float fCoeff, fBlend;
int Mode;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
    float maskValue;
    float2 maskCoord = In;

    // Adjust coordinates for mask application based on mode
    if (Mode == 1) {
        if (In.y < fCoeff) {
            In.y = (-In.y / fCoeff) + In.y + 1;
        }
        maskCoord.y = (In.y < 0.5) ? 2.0 * In.y : 2.0 * (1.0 - In.y);  // Reflect vertically from middle
    }
    else if (Mode == 2) {
        if (In.x < fCoeff) {
            In.x = (-In.x / fCoeff) + In.x + 1;
        }
        maskCoord.x = (In.x < 0.5) ? 2.0 * In.x : 2.0 * (1.0 - In.x);  // Reflect horizontally from middle
    }
    else if (Mode == 3) {
        if (In.x > fCoeff) {
            In.x = ((In.x - 1) * fCoeff) / (fCoeff - 1);
        }
        maskCoord.x = (In.x > 0.5) ? 2.0 * (In.x - 0.5) : 2.0 * (0.5 - In.x);  // Reflect horizontally from middle
    }
    else {  // Mode 0 by default
        if (In.y > fCoeff) {
            In.y = ((In.y - 1) * fCoeff) / (fCoeff - 1);
        }
        maskCoord.y = (In.y > 0.5) ? 2.0 * (In.y - 0.5) : 2.0 * (0.5 - In.y);  // Reflect vertically from middle
    }

    maskValue = tex2D(mask, maskCoord).r;  // Sample mask texture using modified coordinates
    float4 bgColor = tex2D(bg, In);
    return float4(bgColor.rgb, (1.0 - fBlend) * maskValue);  // Apply mask to alpha or reflection
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); }}
