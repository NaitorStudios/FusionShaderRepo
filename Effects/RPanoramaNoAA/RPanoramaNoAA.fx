sampler2D bg : register(s1);

float fPixelWidth;
float fPixelHeight;

int zoom;
int pDir;
int noWrap;

float4 PixelShader(float2 texCoord: TEXCOORD0) : COLOR {
  float fB;
  float fC;
  
  float2 posTex;
  float4 color = float4(0.0, 0.0, 0.0, 1.0);
  
  if(pDir == 0){
    fB = 1.0 - (zoom * fPixelHeight);
    fC = max(0.02, 1.0 + (fB - 1.0) * 4.0 * pow((texCoord.x - 0.5), 2.0));
    
    posTex = texCoord * float2(1.0, fC) + float2(0.0, (1.0 - fC) / 2.0);
    
    if(noWrap == 0 || (posTex.y >= 0.0 && posTex.y <= 1.0)){
      color = tex2D(bg, posTex);
    }
  } else {
    fB = 1.0 - (zoom * fPixelWidth);
    fC = max(0.05, 1.0 + (fB - 1.0) * 4.0 * pow((texCoord.y - 0.5), 2.0));
    
    posTex = texCoord * float2(fC, 1.0) + float2((1.0 - fC) / 2.0, 0.0);
    
    if(noWrap == 0 || (posTex.x >= 0.0 && posTex.x <= 1.0)){
      color = tex2D(bg, posTex);
    }
  }
  
  return color;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 PixelShader(); }}