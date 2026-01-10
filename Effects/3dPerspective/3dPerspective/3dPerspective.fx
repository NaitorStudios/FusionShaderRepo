// 3d Perspective Shader
// v1.0
// By MuddyMole / Sketchy

sampler2D img = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
  AddressU = Border;
  AddressV = Border;
  BorderColor = float4(0, 0, 0, 0);
};

float fH, fV, fD, fZ;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
  float dH = fH * 0.0174533;
  float dV = fV * 0.0174533;
  float3 p = float3(In.x, In.y, 0.0);
  float3 c = float3(0.5, 0.5, 0.0 - fD);
  float3 o = float3(0.5, 0.5, 0.0);
  p -= o;
  float3 p2 = float3(
                (p.x * cos(dH)) + (p.z * sin(dH)),
                p.y,
                (-1.0 * p.x * sin(dH)) + (p.z * cos(dH))
              );
  float3 p3 = float3(
                p2.x,
                (p2.y * cos(dV)) - (p2.z * sin(dV)),
                (p2.y * sin(dV)) + (p2.z * cos(dV))
              );
  p3 += o;
  c -= o;
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
  float s = (0 - c3.z) / (p3.z - c3.z);
  float3 t = lerp(c3, p3, s);
  float2 xy = float2(t.x, t.y);
  float4 outColor = tex2D( img, ((xy-0.5)/fZ)+0.5);
  return outColor;
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_0 ps_main();
  }
}