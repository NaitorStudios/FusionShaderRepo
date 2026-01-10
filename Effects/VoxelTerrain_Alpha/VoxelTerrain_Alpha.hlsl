struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float> t_imgHeightmap : register(t1);
sampler s_imgHeightmap : register(s1);
Texture2D<float4> t_imgTexturemap : register(t2);
sampler s_imgTexturemap : register(s2);
Texture2D<float4> t_imgSky : register(t3);
sampler s_imgSky : register(s3);

cbuffer PS_VARIABLES:register(b0)
{
  // Declare the parameters imported from CF2.5.
  float fX, fY, fZ, fPan, fCosPan, fSinPan, fCosTilt, fSinTilt, fCosRoll, fSinRoll, fYScale;
  float4 cFog;
}

cbuffer PS_PIXELSIZE : register(b1)
{
  float fPixelWidth;
  float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
  float4 color = _color;
  if ( color.a != 0 ) {
    color.xyz /= color.a;
  }
  return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET {
  float4 outColor = float4( 0.0, 0.0, 0.0, 0.0 );
  float3 p = float3(( In.texCoord.x - 0.5 ), (0.5 - In.texCoord.y ) * fPixelWidth / fPixelHeight, 0.5);
  p = float3(p.x, ( p.y * fCosTilt ) + ( p.z * fSinTilt ),( p.y * fSinTilt ) - ( p.z * fCosTilt ));
  p = normalize(float3(( p.x * fCosPan ) - ( p.z * fSinPan ), p.y, ( p.x * fSinPan ) + ( p.z * fCosPan )));
  float3 step = p * 0.003; // --> ray length factor (higher=more depth, but more "flicker" on diagonal rays)
  float3 ray = float3( fX, fY, fZ );
  for ( int i = 0; i < 67; i++ ) {
    ray += step;
    ray.x = ((ray.x % 1.0) + 1.0) % 1.0;
    ray.z = ((ray.z % 1.0) + 1.0) % 1.0;
    if ( t_imgHeightmap.SampleLevel( s_imgHeightmap, ray.xz, 0 ) * fYScale > ray.y ) {
      outColor = t_imgTexturemap.SampleLevel( s_imgTexturemap, ray.xz, 0 );
      outColor.rgb = lerp( outColor.rgb, cFog.rgb, ((i / 67.0) - 0.5) * 2.0 );
      outColor.a = 1.0;
      break;
    }
  }
  if (outColor.a < 1.0) {
    outColor = t_imgSky.SampleLevel( s_imgSky, float2(((((In.texCoord.x + ( fPan / 90.0 )) * 0.25) % 1.0) + 1.0) % 1.0, In.texCoord.y * 2.0 ), 0);	
  }
  return outColor * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
  return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
  return effect(In, true);
}