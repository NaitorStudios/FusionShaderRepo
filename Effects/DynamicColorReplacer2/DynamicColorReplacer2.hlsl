struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};


Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);


cbuffer PS_VARIABLES : register(b0)
{
float4 from[15], to[15];
};



#define THRESHOLD (0.33/255)

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float4 o = img.Sample(imgSampler, In.texCoord) * In.Tint;
	for (int i=0; i<15; i++) {
		if (distance(o.rgb, from[i].rgb) < THRESHOLD) {
			o.rgb = to[i].rgb;
			}
	}
	
	return o;
	
}
