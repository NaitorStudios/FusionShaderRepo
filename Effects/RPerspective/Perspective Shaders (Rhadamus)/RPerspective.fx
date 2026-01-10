sampler2D bg : register(s1) = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
};

float fPixelWidth;
float fPixelHeight;

int zoom;
int pDir;
int orientation;
int noWrap;

float4 PixelShader(float2 texCoord: TEXCOORD0) : COLOR {
  float fB;
  
  float2 posTex;
  float4 color = float4(0.0, 0.0, 0.0, 1.0);
  
  if(pDir != 0){
    fB = 1.0 - (zoom * fPixelHeight);
    float y;
    
    if(orientation == 0){
      y = texCoord.y;
    } else {
      y = 1.0 - texCoord.y;
    }
    
    float ScreenX = (1.0 - (1.0 - fB) * y);
    posTex = texCoord * float2(ScreenX, 1.0) + float2((1.0 - ScreenX) / 2.0, 0.0);
    
    if(noWrap == 0 || (posTex.x >= 0.0 && posTex.x <= 1.0)){
      color = tex2D(bg, posTex);
    }
  } else {
    fB = 1.0 - (zoom * fPixelWidth);
    float x;
    
    if(orientation == 0){
      x = texCoord.x;
    } else {
      x = 1.0 - texCoord.x;
    }
    
    float ScreenY = (1.0 - (1.0 - fB) * x);
    posTex = texCoord * float2(1.0, ScreenY) + float2(0.0, (1.0 - ScreenY) / 2.0);
    
    if(noWrap == 0 || (posTex.y >= 0.0 && posTex.y <= 1.0)){
      color = tex2D(bg, posTex);
    }
  }
  
  return color;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 PixelShader(); }}