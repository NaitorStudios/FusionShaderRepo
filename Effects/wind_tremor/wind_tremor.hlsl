Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

struct PS_INPUT{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

cbuffer PS_VARIABLES : register(b0){
	float raito;
	float weight;
};

float4 ps_main( PS_INPUT uv ) : SV_TARGET{
	float y = (1.0 - uv.texCoord.y);
	y = ( y * y * 0.333333 ) * weight;
	uv.texCoord.x += sin( y ) * ( raito ) ;
	float4 color = Texture0.Sample(TextureSampler0 , uv.texCoord );
	return color;
}
