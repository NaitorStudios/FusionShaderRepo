// This shader requires DX11
float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
  return float4(0.0, 0.0, 0.0, 0.0);
}

technique tech_main {
  pass P0 {
    PixelShader = compile ps_2_0 ps_main();
  }
}