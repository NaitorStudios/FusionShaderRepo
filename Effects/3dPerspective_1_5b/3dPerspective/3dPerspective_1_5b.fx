// 3d Perspective Shader
// v1.5b (basic)
// By MuddyMole / Sketchy

// Set the sampler state to use linear texture filtering and make transparent any pixel with a coordinate outside the range 0-1.
sampler2D img = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
  AddressU = Border;
  AddressV = Border;
  BorderColor = float4(0, 0, 0, 0);
};

// Declare the parameters imported from CF2.5.
float fH, fV, fR, fD, fZ, fPixelWidth, fPixelHeight;
int iM;

// Define a helper function to rotate any float3 vector about the X axis.
float3 rotateX(float3 vec, float ang) {
  return float3(vec.x, (vec.y * cos(ang)) - (vec.z * sin(ang)), (vec.y * sin(ang)) + (vec.z * cos(ang)));
}

// Define a helper function to rotate any float3 vector about the Y axis.
float3 rotateY(float3 vec, float ang) {
  return float3((vec.x * cos(ang)) + (vec.z * sin(ang)), vec.y, (vec.z * cos(ang)) - (vec.x * sin(ang))); 
}

// Define a helper function to rotate any float3 vector about the Z axis. This isn't used here, but I'm including it in case anyone wants to implement it themselves.
float3 rotateZ(float3 vec, float ang) {
  return float3((vec.x * cos(ang)) - (vec.y * sin(ang)), (vec.x * sin(ang)) + (vec.y * cos(ang)), vec.z);
}

// Main shader function.
float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
  // Convert the angles from degrees to radians.
  float dH = radians(fH);
  float dV = radians(fV);
  float dR = radians(fR);
	
  // Create a point "p" in 3D space from the 2D position of the current pixel. fPixelWidth and fPixelHeight are used to correct for non-square textures. Coordinates are relative to the centre of the texture.
  // Essentially, we're going to convert the 2D texture into a 3D plane, and then instead of rotating it, we'll move the camera around it.
  float3 p = float3((In.x - 0.5) / fPixelWidth, (In.y - 0.5) / fPixelHeight, 0.0);
	
  // Create another point "c" representing the camera, placed infront of the texture (along the X axis).
  float3 c = float3(0.0, 0.0, 0.0 - fD);
	
  // Set the origin (where the camera is aimed) to the centre of the texture.
  float3 o = float3(0.5 / fPixelWidth, 0.5 / fPixelHeight, 0.0);
	
  // Rotate "p" on the Y-axis and then X-axis, around the origin, and then move it to make its position relative to the original coordinate system again.
  p = rotateZ(rotateX(rotateY(p, dH), dV), dR) + o;
	
  // Repeat the exact same process for the camera "c".
  c = rotateZ(rotateX(rotateY(c, dH), dV), dR) + o;
	
  // Find which side of the card is showing to the camera. Most of the complexity comes from the need to support any angle values, and not just those in the range -180 to +180 degrees.
  float cH = ((((fH % 360.0) + 450.0) % 360.0));
  float cV = ((((fV % 360.0) + 450.0) % 360.0));
  int f = 0;
  if (cH > 180) { f++; }
  if (cV > 180) { f = (f + 1) % 2; }
	
  // Trace a line from the camera "c" to the pixel "p", and find the point along it where Z=0 (where it intersects the texture plane), as a proportion of the total distance between them.
  // eg. s=0 means the camera's position; s=1 means the pixel's position; 0.5 means halfway between the camera and the pixel.
  float s = (0 - c.z) / (p.z - c.z);
	
  // Use linear interpolation to find the X and Y coordinates at the point of intersection.
  float3 t = lerp(c, p, s);
	
  // Convert coordinaates back to texture units (ranging from 0-1, instead of pixels), and scale the image to avoid parts being cut off when the texture is rotated.
  float2 xy = ((float2(t.x * fPixelWidth, t.y * fPixelHeight) - 0.5) / fZ) + 0.5;
	
  // Sample the texture.
  if (f==1 && iM == 0) { xy.x = 1.0 - xy.x; }
  return tex2D(img, xy);
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_0 ps_main();
  }
}