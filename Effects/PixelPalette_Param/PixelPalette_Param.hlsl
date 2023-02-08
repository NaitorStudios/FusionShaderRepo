// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES:register(b0)
{
	float4 c[20];
}


/*float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}*/

float4 ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
	float4 output =  img.Sample(imgSampler, In.texCoord);
	int index = img.Sample(imgSampler, In.texCoord).r*255;
	output = float4(c[index].rgb,output.a) * In.Tint;
	
	return output;
}


