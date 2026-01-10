struct PS_INPUT {
  float4 tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

Texture2D<float4> bgTexture : register(t1);
sampler bg : register(s1);

cbuffer PS_PIXELSIZE : register(b1) {
  float fPixelWidth;
  float fPixelHeight;
};

cbuffer PS_VARIABLES : register(b0) {
  int pDir;
  int zoom;
  int noWrap;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET {
  float fB;
  float fC;
  
  float2 posTex;
  float4 color = float4(0.0, 0.0, 0.0, 1.0);
  
  if(pDir == 0){
    fB = 1.0 - (zoom * fPixelHeight);
    fC = max(0.02, 1.0 + (fB - 1.0) * 4.0 * pow((In.texCoord.x - 0.5), 2.0));
    
    posTex = In.texCoord * float2(1.0, fC) + float2(0.0, (1.0 - fC) / 2.0);
    
    if(noWrap == 0 || (posTex.y >= 0.0 && posTex.y <= 1.0)){
      color = bgTexture.Sample(bg, posTex);
    }
  } else {
    fB = 1.0 - (zoom * fPixelWidth);
    fC = max(0.05, 1.0 + (fB - 1.0) * 4.0 * pow((In.texCoord.y - 0.5), 2.0));
    
    posTex = In.texCoord * float2(fC, 1.0) + float2((1.0 - fC) / 2.0, 0.0);
    
    if(noWrap == 0 || (posTex.x >= 0.0 && posTex.x <= 1.0)){
      color = bgTexture.Sample(bg, posTex);
    }
  }
  
  return color;
}