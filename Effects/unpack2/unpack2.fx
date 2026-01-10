
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

sampler2D bkd : register(s1);
int selectedImage;

float RightShift(float value, int shift) {
    // Use division to perform the right shift
    return floor(value / exp2(shift));
}

float BitwiseAnd(float a, float b) {
    float result = 0.0;
    float bitValue = 1.0;
    
    // Iterate over each bit
    for (int i = 0; i < 32; i++) {
        // Check if the i-th bit is set in both numbers
        float aBit = fmod(floor(a / bitValue), 2.0);
        float bBit = fmod(floor(b / bitValue), 2.0);
        
        // If both bits are set, set the corresponding bit in the result
        if (aBit > 0.0 && bBit > 0.0) {
            result += bitValue;
        }
        
        // Move to the next bit
        bitValue *= 2.0;
    }
    
    return result;
}

// The main shader function (note that the function returns a float4 colour, not a structure)
float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {
    float4 pixel = tex2D(bkd, In);
    int i = int(pixel[int(selectedImage / 4.0)] * 255);
    
    // Perform the right shift operation
    float shiftedValue = RightShift(i, 2 * int(selectedImage % 4.0));
    
    // Perform the bitwise AND operation
    float l = BitwiseAnd(shiftedValue, 3.0);
    
    float4 Out_Color = float4(l / 3.0, l / 3.0, l / 3.0, 1.0);
    return Out_Color;
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_0 ps_main();
  }
}