Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0) {
	// IMPORTANT: the parameters must be in the same order as in your XML file
    bool flipX;
    bool flipY;
};

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

//Main Shader Function
float4 ps_main( in PS_INPUT In ) : SV_TARGET {

    float2 uv = float2(In.texCoord);
    float4 color;

    if(flipX){
        uv.x = 1.0 - In.texCoord.x;
    }

    if(flipY){
        uv.y = 1.0 - In.texCoord.y;
    }
    
    color = img.Sample(imgSampler, float2(uv));
    return color;

}