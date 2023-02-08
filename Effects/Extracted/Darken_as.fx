sampler2D img;
sampler2D bkd : register(s1);

float4 ps_main(float4 color : COLOR0,in float2 In : TEXCOORD0) : COLOR0	{
  float4 L = tex2D(img,In);
  float4 B = tex2D(bkd,In);
  float4 O = min(L,B);
  color.rgb = O.rgb;
  color.a= L.a;
  return color;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
