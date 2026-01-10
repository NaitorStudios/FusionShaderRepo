// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Define textures and sampler
Texture2D<float4> t_img : register(t0); // object texture
sampler s_img : register(s0);

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

// The main shader function (note that the function returns a float4 colour, not a structure)
float4 ps_main( in PS_INPUT In ) : SV_TARGET {

    // Calculate grid position (4x4 grid)
    int gridX = int(In.texCoord.x * 4.0);
    int gridY = int(In.texCoord.y * 4.0);
    
    // Calculate selected image based on grid position
    int selectedImage = gridY * 4 + gridX;
    
    // Adjust texture coordinates to fit within the grid cell
    float2 gridCellSize = 1.0 / 4.0;
    float2 gridOffset = float2(gridX, gridY) * gridCellSize;
    float2 localCoord = (In.texCoord - gridOffset) / gridCellSize;
    
    // Sample the texture using the adjusted coordinates
    float4 pixel = Demultiply(t_img.Sample(s_img, localCoord));
    
    // Get the selected channel based on selectedImage value
    uint channelIndex = uint(selectedImage / 4.0);
    uint channelShift = 2 * uint(selectedImage % 4.0);
    
    // Extract the value from the selected channel
    uint i = pixel[uint(channelIndex)] * 255;
    
    // Perform the right shift, then bitwise AND operation
    uint l = (i >> channelShift) & 3u;
    
    // Normalize the result and set the output color
    float4 Out_Color = float4(l / 3.0, l / 3.0, l / 3.0, 1.0);
    return Out_Color;
}
