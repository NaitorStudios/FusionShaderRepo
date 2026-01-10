// 3d Perspective Shader
// v1.1
// By MuddyMole / Sketchy

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES:register(b0)
{
	// Declare the parameters imported from CF2.5.
	float fH, fV, fD, fZ;
	float4 cA, cD;
	float fDx, fDy, fDz;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET {
	// Convert the angles from degrees to radians.
	float dH = fH * 0.0174533;
	float dV = fV * 0.0174533;
	
	// Create a point "p" in 3D space from the 2D position of the current pixel.
	// fPixelWidth and fPixelHeight are used to correct for non-square textures.
	// Coordinates are relative to the centre of the texture.
	// Essentially, we're going to convert the 2D texture into a 3D plane, and
	// then instead of rotating it, we'll move the camera around it.
	float3 p = float3((In.texCoord.x - 0.5) / fPixelWidth, (In.texCoord.y - 0.5) / fPixelHeight, 0.0);
	
	// Create another point "c" representing the camera, placed infront of the
	// texture (along the X axis).
	float3 c = float3(0.0, 0.0, 0.0 - fD);
	
	// Set the origin (where the camera is aimed) to the centre of the texture.
	float3 o = float3(0.5 / fPixelWidth, 0.5 / fPixelHeight, 0.0);
	
	// Rotate "p" on the Y-axis, around the origin.
	float3 p2 = float3(
				(p.x * cos(dH)) + (p.z * sin(dH)),
				p.y,
				(-1.0 * p.x * sin(dH)) + (p.z * cos(dH))
				);
	
	// Rotate "p" on the X-axis, around the origin.
	float3 p3 = float3(
				p2.x,
				(p2.y * cos(dV)) - (p2.z * sin(dV)),
				(p2.y * sin(dV)) + (p2.z * cos(dV))
				);
	
	// Move "p" to make its position relative to the original coordinate system.
	p3 += o;
	
	// Repeat the exact same process for the camera "c".
	float3 c2 = float3(
				(c.x * cos(dH)) + (c.z * sin(dH)),
				c.y,
				(-1.0 * c.x * sin(dH)) + (c.z * cos(dH))
				);
	float3 c3 = float3(
				c2.x,
				(c2.y * cos(dV)) - (c2.z * sin(dV)),
				(c2.y * sin(dV)) + (c2.z * cos(dV))
				);
	c3 += o;
	
	// Trace a line from the camera "c" to the pixel "p", and find the point
	// along it where Z=0 (where it intersects the texture plane), as a proportion
	// of the total distance between them.
	// eg. s=0 means the camera's position; s=1 means the pixel's position; 0.5 means
	// halfway between the camera and the pixel.
	float s = (0 - c3.z) / (p3.z - c3.z);
	
	// Use linear interpolation to find the X and Y coordinates at the point of
	// intersection.
	float3 t = lerp(c3, p3, s);
	
	// Convert coordinaates back to texture units (ranging from 0-1, instead of pixels),
	// and scale the image to avoid parts being cut off when the texture is rotated.
	float2 xy = ((float2(t.x * fPixelWidth, t.y * fPixelHeight) - 0.5) / fZ) + 0.5;
	
	// Sample the texture.
	float4 outColor = Demultiply(img.Sample(imgSampler, xy));
	
	// Create a directional light vector.
	float3 n = float3( fDx, fDy, fDz );
	
	// Calculate the light received from the directional light.
	float3 l = max(0.0, dot(normalize(c3), normalize(n))) * cD.rgb;
	
	// Multiply the pixel's colour by the combined ambient and directional light.
	outColor.rgb *= (cA.rgb + l);
 
	if (PM)
		outColor.rgb *= outColor.a;
	
  return outColor * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}