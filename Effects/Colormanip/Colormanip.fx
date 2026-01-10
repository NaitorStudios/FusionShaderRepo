// Defines the input parameters passed to the pixel shader function
// Texture contains the X and Y coordinates of the pixel in the object texture being processed
// They are UV coordinates between 0 (left/top) and 1 (right/bottom)
struct PS_INPUT
{
    float4 Position : POSITION;
    float2 Texture : TEXCOORD0;

};

// Defines the output value of the pixel shader function
struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

// A 2D sampler associated with the object texture passed to the shader
sampler2D img;
// Float parameters, initialize these in the XML
float colorR;
float colorG;
float colorB;

float4 ps_main(float2 coords: TEXCOORD0) : COLOR0
{
    // This color variable contains the current proccessed pixel of the object texture
    float4 color = tex2D(img, float2(coords.x, coords.y));
    // Modify the colors by multiplying them by the parameters
    color.rgb *= float3(colorR, colorG, colorB);

    // Return the final pixel color
    return color;
}

// Used for compiling the shader
technique CompileTechnique
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 ps_main();
    }
}
