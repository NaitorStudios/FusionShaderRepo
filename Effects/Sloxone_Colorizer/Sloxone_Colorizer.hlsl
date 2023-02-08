// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{ 
	float factor,red,green,blue;
}
 
float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
} 

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
             
    PS_OUTPUT Out;
    float4 spr = Demultiply(img.Sample(imgSampler,  In.texCoord)) * In.Tint;
 
    float4 col = float4(red, green, blue, 1.0);
    spr.rgb    = 1.0 * spr.rgb;
    col.a      = factor;
    float4 f   = lerp(spr, col, col.a);
    if((spr.r>0.0) || (spr.g>0.0) || (spr.b>0.0))
		Out.Color = f;
    else
		Out.Color = 0.0;

	return Out.Color;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
             
    PS_OUTPUT Out;
    float4 spr = Demultiply(img.Sample(imgSampler,  In.texCoord)) * In.Tint;
 
    float4 col = float4(red, green, blue, 1.0);
    spr.rgb    = 1.0 * spr.rgb;
    col.a      = factor;
    float4 f   = lerp(spr, col, col.a);
    if((spr.r>0.0) || (spr.g>0.0) || (spr.b>0.0))
		Out.Color = f;
    else
		Out.Color = 0.0;

	Out.Color.rgb *= Out.Color.a;
	return Out.Color;
}