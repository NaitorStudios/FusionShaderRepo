sampler2D bg : register(s1) = sampler_state {
  MinFilter = Linear;
  MagFilter = Linear;
};

float fPixelWidth;
float fPixelHeight;

int zoom;
int waves;
int offset;
int pDir;
int noWrap;

float4 PixelShader(float2 texCoord: TEXCOORD0) : COLOR {
  float delta = 3.141592 / 180.0;
  
  float2 posTex;
  float4 color = float4(0.0, 0.0, 0.0, 1.0);
  
  if(pDir == 0){
    float zoom2 = zoom * fPixelWidth;
    float waves2 = waves * 360;
    float y = texCoord.y;
    
    float ScreenX = 1.0 + sin((y * waves2 + offset) * delta) * zoom2;
    posTex = texCoord + float2((1.0 - ScreenX) / 2.0, 0.0);
    
    if(noWrap == 0 || (posTex.x >= 0.0 && posTex.x <= 1.0)){
      color = tex2D(bg, posTex);
    }
  } else {
    float zoom2 = zoom * fPixelHeight;
    float waves2 = waves / fPixelHeight;
    float x = texCoord.x;
    
    float ScreenY = 1.0 - sin(-(x * waves2 + offset) * delta) * zoom2;
    posTex = texCoord + float2(0.0, (2.0 - 2.0 * ScreenY) / 2.0);
    
    if(noWrap == 0 || (posTex.y >= 0.0 && posTex.y <= 1.0)){
      color = tex2D(bg, posTex);
    }
  }
  
  return color;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 PixelShader(); }}