// 3d Perspective Shader
// v1.3
// By MuddyMole / Sketchy

// Set the sampler state to use linear texture filtering and make transparent
// any pixel with a coordinate outside the range 0-1.
sampler2D img = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
  AddressU = Border;
  AddressV = Border;
  BorderColor = float4(0, 0, 0, 0);
};
sampler2D iR = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
  AddressU = Border;
  AddressV = Border;
  BorderColor = float4(0, 0, 0, 0);
};

// Declare the parameters imported from CF2.5.
float fH, fV, fD, fZ, fDx, fDy, fDz, fPixelWidth, fPixelHeight;
float4 cA, cD;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
	// Convert the angles from degrees to radians.
	float dH = radians(fH);
	float dV = radians(fV);
	
	// Create a point "p" in 3D space from the 2D position of the current pixel.
	// fPixelWidth and fPixelHeight are used to correct for non-square textures.
	// Coordinates are relative to the centre of the texture.
	// Essentially, we're going to convert the 2D texture into a 3D plane, and
	// then instead of rotating it, we'll move the camera around it.
	float3 p = float3((In.x - 0.5) / fPixelWidth, (In.y - 0.5) / fPixelHeight, 0.0);
	
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
	c3+=o;
	
	// Create a surface normal vector "u", and rotate it in the opposite direction, using
	// the reverse order of operations (X axis first, then Y axis).
	float3 u = float3( 0.0, 0.0, 1.0 ); 
	float3 u2 = float3(
				u.x,
				(u.y * cos(-1 * dV)) - (u.z * sin(-1 * dV)),
				(u.y * sin(-1 * dV)) + (u.z * cos(-1 * dV))
				);
	float3 u3 = float3(
				(u2.x * cos(-1 * dH)) + (u2.z * sin(-1 * dH)),
				u2.y,
				(-1.0 * u2.x * sin(-1 * dH)) + (u2.z * cos(-1 * dH))
				);
	
	// Find which side of the card is showing to the camera.
	// Most of the complexity comes from making it support any angle values, and not
	// just those in the range -180 to +180 degrees.
	float cH = (((( fH % 360.0 ) + 450.0 ) % 360.0 ));
	float cV = (((( fV % 360.0 ) + 450.0 ) % 360.0 ));
	int f = ((cH > 180.0 ? 1.0f : 0.0f) + (cV > 180.0 ? 1.0f : 0.0f)) % 2.0;
	
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
	
	// Create a directional light vector.
	float3 n = float3(fDx, fDy, fDz);
	
	// Sample the texture.
	float4 outColor = float4(0,0,0,0);
	if (f == 0) {
	outColor = tex2D(img, xy);
	} else {
	outColor = tex2D(iR, float2(1.0 - xy.x, xy.y));
	// If the reverse face is showing to the camera, reverse the light vector.
	n *= -1;
	}
	
	// Calculate the light received from the directional light.
	float3 l = max(0.0, dot(normalize(u3), normalize(n))) * cD.rgb;
	
	// Multiply the pixel's colour by the combined ambient and directional light.
	outColor.rgb *= (cA.rgb + l);
	return outColor;
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_0 ps_main();
  }
}