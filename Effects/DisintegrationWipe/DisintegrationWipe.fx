// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 texCoord    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0 = sampler_state {
AddressU = border;
AddressV = border;
BorderColor = float4(1.0,1.0,1.0,0.0);
};

float progress;     // Progress is now in pixels
float angle;
float fPixelWidth;
float fPixelHeight;

const float2 center = float2(0.5, 0.5);

// Hash function to generate pseudo-random numbers
float hash(float2 p)
{
    return frac(sin(dot(p ,float2(12.9898,78.233))) * 43758.5453);
}

// Function to generate a random float between -0.5 and 0.5
float rand(float2 p)
{
    return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453123) - 0.5;
}

float4 ps_main( in PS_INPUT In ) : COLOR0
{
    float2 texCoord = In.texCoord;

    // Calculate direction vector based on angle
    float rAngle = radians(angle - 90.0);
    float2 dir = float2(cos(rAngle), sin(rAngle));
    dir = normalize(dir);
    dir /= abs(dir.x) + abs(dir.y);

    // Calculate the dot product of direction and center
    float d = dot(dir, center);

    // Calculate texel size along the direction vector
    float2 pixelSize = float2(fPixelWidth, fPixelHeight);
    float texelStep = length(dir * pixelSize);

    // Convert progress from pixels to texture coordinate units
    float totalProgress = progress * texelStep;

    // Calculate the position along the wipe line
    float position = dot(dir, texCoord) - (d - 0.5 + totalProgress);

    // Check if the pixel is beyond the wipe line
    if (position > 0.0)
    {
        // Calculate the opposite angle of the wipe direction
        float oppositeAngle = rAngle + 3.14159265; // Add PI to get the opposite direction

        // Generate a random angle within a 180-degree cone opposite to the wipe direction
        float randomOffset = rand(texCoord) * 3.14159265; // Random offset between -PI/2 and +PI/2
        float randAngle = oppositeAngle + randomOffset;

        // Calculate the random direction vector
        float2 randomDir = float2(cos(randAngle), sin(randAngle));

        // Calculate displacement amount
        float maxDisplacement = 0.1; // Adjust this value as needed
        float displacement = position * maxDisplacement;

        // Offset the texture coordinates
        texCoord += randomDir * displacement;
    }

    // Sample the texture with the (possibly) modified texture coordinates
    float4 color = tex2D(Tex0, texCoord);

    return color;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}
