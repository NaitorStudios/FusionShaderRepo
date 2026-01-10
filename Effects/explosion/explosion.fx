sampler2D bkd : register(s1) = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
  AddressU = Clamp;
  AddressV = Clamp;
  BorderColor = float4(0, 0, 0, 0);
};

// Declare the parameters imported from CF2.5.
float fTime, fPixelWidth, fPixelHeight;

// Main shader function.
float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
  float ar = fPixelWidth / fPixelHeight;
  float2 uv = In;
  float radius = length(float2((uv.x - 0.5) / ar, uv.y - 0.5)) + 0.1 - fTime / 20.0;
  float angle = atan2(uv.y - 0.5, (uv.x - 0.5) / ar);
  float distortion = smoothstep(0.1, 0.2, radius) * smoothstep(0.3, 0.2, radius) * smoothstep(0.0, 1.0, radius);
  float4 light = float4(1.0, 0.8, 0.7, 1.0) * smoothstep(0.5, 0.0, radius) * 1.75 - fTime / 20.0;
  uv += distortion * float2(cos(angle), sin(angle));
  return tex2D(bkd, uv) + light;
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_a ps_main();
  }
}