// Global variables
sampler2D Tex0;
float PixelSize;
float ImageWidth;
float ImageHeight;

float map(float value, float min1, float max1, float min2, float max2)
{
     float perc = (value - min1) / (max1 - min1);
     float val = perc * (max2 - min2) + min2;
     return val;
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
 
  int scale = PixelSize;
  int width = ImageWidth;
  int height = ImageHeight;

  float x = map(In.x, -1, 1, 0, width);
  float y = map(In.y, -1, 1, 0, height);
  int intX = x;
  int intY = y;
  intX = intX / scale * scale;
  intY = intY / scale * scale;
  float newX = map(intX, 0, width, -1, 1);
  float newY = map(intY, 0, height, -1, 1);

  float2 texCoords = float2(newX, newY);
  return tex2D(Tex0, texCoords);
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}