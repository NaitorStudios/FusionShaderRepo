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
  int offset;
  int waves;
  int noWrap;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET {
  float delta = 3.141592 / 180.0;
  
  float2 posTex;
  float4 color = float4(0.0, 0.0, 0.0, 1.0);
  
  if(pDir == 0){
    float zoom2 = zoom * fPixelWidth;
    float waves2 = waves * 360;
    float y = In.texCoord.y;
    
    float ScreenX = 1.0 + sin((y * waves2 + offset) * delta) * zoom2;
    posTex = In.texCoord + float2((1.0 - ScreenX) / 2.0, 0.0);
    
    if(noWrap == 0 || (posTex.x >= 0.0 && posTex.x <= 1.0)){
      color = bgTexture.Sample(bg, posTex);
    }
  } else {
    float zoom2 = zoom * fPixelHeight;
    float waves2 = waves / fPixelHeight;
    float x = In.texCoord.x;
    
    float ScreenY = 1.0 - sin(-(x * waves2 + offset) * delta) * zoom2;
    posTex = In.texCoord + float2(0.0, (2.0 - 2.0 * ScreenY) / 2.0);
    
    if(noWrap == 0 || (posTex.y >= 0.0 && posTex.y <= 1.0)){
      color = bgTexture.Sample(bg, posTex);
    }
  }
  
  return color;
}