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

sampler2D img;

float fPixelWidth;   // Width of a pixel in texture space
float fPixelHeight;  // Height of a pixel in texture space

// Function to perform right shift operation using division
float RightShift(float value, int shift) {
    return floor(value / exp2(shift));
}

// Function to perform bitwise AND operation
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

// Main pixel shader function
float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {
    // Calculate grid position (4x4 grid)
    int gridX = int(In.x * 4.0);
    int gridY = int(In.y * 4.0);
    
    // Calculate selected image based on grid position
    int selectedImage = gridY * 4 + gridX;
    
    // Adjust texture coordinates to fit within the grid cell
    float2 gridCellSize = 1.0 / 4.0;
    float2 gridOffset = float2(gridX, gridY) * gridCellSize;
    float2 localCoord = (In - gridOffset) / gridCellSize;
    
    // Sample the texture using the adjusted coordinates
    float4 pixel = tex2D(img, localCoord);
    
    // Get the selected channel based on selectedImage value
    int channelIndex = int(selectedImage / 4.0);
    int channelShift = 2 * int(selectedImage % 4.0);
    
    // Extract the value from the selected channel
    int i = int(pixel[channelIndex] * 255);
    
    // Perform the right shift operation
    float shiftedValue = RightShift(i, channelShift);
    
    // Perform the bitwise AND operation
    float l = BitwiseAnd(shiftedValue, 3.0);
    
    // Normalize the result and set the output color
    float4 Out_Color = float4(l / 3.0, l / 3.0, l / 3.0, 1.0);
    return Out_Color;
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_b ps_main();
  }
}
