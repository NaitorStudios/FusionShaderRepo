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

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float tiltX, tiltY, depthOfField;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{

  // Convert degrees to radians
  float aX = radians(tiltX);
  float aY = radians(tiltY);

  // Get pixel coordinates relative to the centre (x:0.5, y:0.5, z:0.5)
  float3 p1 = float3(
    In.texCoord.x - 0.5, // x
    In.texCoord.y - 0.5, // y
    0.0            // z
  );

  // Get new position after rotating
  float3 p2 = float3(
    p1.x / cos(aX), // x <---- BROKEN!
    p1.y / cos(aY), // y <---- BROKEN!
    ((p1.x * sin(aX) / cos(aX)) + (p1.y * sin(aY) / cos(aY))) * depthOfField+ 0.5 // z <---- BROKEN!
  );

  // Get texture coordinates after applying perspective
  float2 p3 = float2(
    p2.x / p2.z /2.0 + 0.5,
    p2.y / p2.z /2.0+ 0.5
  ); 

  // Sample pixel from texture
  float4 outColor = Demultiply(img.Sample( imgSampler, p3)) ;

/*
  // Debug by showing pixel z
  outColor.rgb = p2.z;
*/

  // Return the sampled pixel
  return outColor * In.Tint;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{

  // Convert degrees to radians
  float aX = radians(tiltX);
  float aY = radians(tiltY);

  // Get pixel coordinates relative to the centre (x:0.5, y:0.5, z:0.5)
  float3 p1 = float3(
    In.texCoord.x - 0.5, // x
    In.texCoord.y - 0.5, // y
    0.0            // z
  );

  // Get new position after rotating
  float3 p2 = float3(
    p1.x / cos(aX), // x <---- BROKEN!
    p1.y / cos(aY), // y <---- BROKEN!
    ((p1.x * sin(aX) / cos(aX)) + (p1.y * sin(aY) / cos(aY))) * depthOfField+ 0.5 // z <---- BROKEN!
  );

  // Get texture coordinates after applying perspective
  float2 p3 = float2(
    p2.x / p2.z /2.0 + 0.5,
    p2.y / p2.z /2.0+ 0.5
  ); 

  // Sample pixel from texture
  float4 outColor = Demultiply(img.Sample( imgSampler, p3)) ;

/*
  // Debug by showing pixel z
  outColor.rgb = p2.z;
*/

  // Return the sampled pixel
  outColor.rgb *= outColor.a;
  return outColor * In.Tint;
}
