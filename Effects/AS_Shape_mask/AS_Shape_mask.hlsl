// Pixel shader Input structure
struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color : SV_TARGET;
};
//Sampler
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

Texture2D<float4> masktex : register(t1);
sampler masktexSampler : register(s1);

cbuffer PS_PIXELSIZE:register(b1){
	float fPixelWidth;
	float fPixelHeight;
}

cbuffer PS_VARIABLES : register(b0)
{
  int mask_x;
  int mask_y;
  int mask_width;
  int mask_height;
};

// main shader function
float4  ps_main(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
float2 input= In.texCoord;
float4 maintexture = Tex0.Sample(Tex0Sampler, input);
if(
(input.x /  fPixelWidth < mask_x )
|| (input.x /  fPixelWidth >( mask_x + mask_width))
|| (input.y /  fPixelHeight < mask_y )
|| (input.y /  fPixelHeight >( mask_y + mask_height))
)
{
color = 0;
}
else
{
float4 masktexture = masktex.Sample(masktexSampler,float2((input.x/  fPixelWidth - mask_x)/mask_width,  (input.y/  fPixelHeight - mask_y)/mask_height ))* In.Tint;
if( masktexture.a != 0 )
{
color.rgb = maintexture.rgb;
color.a = masktexture.a ;
}
else
{
color = 0;
}
}
  return color;
}

//pm

float4  ps_main_pm(float4 color : COLOR0, in PS_INPUT In ) : SV_TARGET
{
float2 input= In.texCoord;
float4 maintexture = Tex0.Sample(Tex0Sampler, input);
if(
(input.x /  fPixelWidth < mask_x )
|| (input.x /  fPixelWidth >( mask_x + mask_width))
|| (input.y /  fPixelHeight < mask_y )
|| (input.y /  fPixelHeight >( mask_y + mask_height))
)
{
color = 0;
}
else
{
float4 masktexture = masktex.Sample(masktexSampler,float2((input.x/  fPixelWidth - mask_x)/mask_width,  (input.y/  fPixelHeight - mask_y)/mask_height ))* In.Tint;
if( masktexture.a != 0 )
{
color.rgb = maintexture.rgb;
color.a = masktexture.a ;
color.rgb *= color.a;
}
else
{
color = 0;
}
}
  return color;
}
