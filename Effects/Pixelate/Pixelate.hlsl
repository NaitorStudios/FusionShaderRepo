
Texture2D<float4> Tex0 : register(t0);
sampler TexSampler0 : register(s0);
float PixelSize;
float ImageWidth;
float ImageHeight;

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color : SV_TARGET;
};


float map(float value, float min1, float max1, float min2, float max2)
{
     float perc = (value - min1) / (max1 - min1);
     float val = perc * (max2 - min2) + min2;
     return val;
}


PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out =  (PS_OUTPUT)0;
 
    int scale = PixelSize;
    int width = ImageWidth;
    int height = ImageHeight;

    float x = map(In.texCoord.x, -1, 1, 0, width);
    float y = map(In.texCoord.y, -1, 1, 0, height);
    uint intX = x;
    uint intY = y;
    intX = intX / scale * scale;
    intY = intY / scale * scale;
    float newX = map(intX, 0, width, -1, 1);
    float newY = map(intY, 0, height, -1, 1);

    float2 texCoords = float2(newX, newY);
    Out.Color = Tex0.Sample(TexSampler0, texCoords);
    return Out;
}

