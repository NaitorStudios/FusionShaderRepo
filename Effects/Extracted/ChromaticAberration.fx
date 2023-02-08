sampler2D img;

float amountX;
float amountY;

float4 ps_main(float2 texCoord: TEXCOORD0) : COLOR {
  float red = tex2D(img, float2(texCoord.x + amountX, texCoord.y + amountY)).r;
  float green = tex2D(img, texCoord).g;
  float blue = tex2D(img, float2(texCoord.x - amountX, texCoord.y - amountY)).b;
  float alpha = tex2D(img, texCoord).a;
  
  return float4(red, green, blue, alpha);
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); }}