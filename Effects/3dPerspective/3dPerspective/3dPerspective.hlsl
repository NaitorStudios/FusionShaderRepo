// 3d Perspective Shader
// v1.0
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
	float fH, fV, fD, fZ;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
  float dH = fH * 0.0174533;
  float dV = fV * 0.0174533;
  float3 p = float3(In.texCoord.x, In.texCoord.y, 0.0);
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
  float4 outColor = Demultiply(img.Sample(imgSampler, ((xy-0.5)/fZ)+0.5));
  return outColor * In.Tint;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
  float dH = fH * 0.0174533;
  float dV = fV * 0.0174533;
  float3 p = float3(In.texCoord.x, In.texCoord.y, 0.0);
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
  float4 outColor = Demultiply(img.Sample(imgSampler, ((xy-0.5)/fZ)+0.5));
  outColor.rgb *= outColor.a;
  return outColor * In.Tint;
}