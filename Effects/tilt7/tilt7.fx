sampler2D img = sampler_state {
  AddressU = Border;
  AddressV = Border;
  BorderColor = float4(0, 0, 0, 0);
};

float tiltX, tiltY, depthOfField;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {

  // Convert degrees to radians
  float aX = radians(tiltX);
  float aY = radians(tiltY);

  // Get pixel coordinates relative to the centre (x:0.5, y:0.5, z:0.5)
  float3 p1 = float3(
    In.x - 0.5, // x
    In.y - 0.5, // y
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
  float4 outColor = tex2D( img, p3);

/*
  // Debug by showing pixel z
  outColor.rgb = p2.z;
*/

  // Return the sampled pixel
  return outColor;
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_a ps_main();
  }
}