// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES:register(b0)
{
	int mask_x;
	int mask_y;
	int mask_width;
	int mask_height;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> masktex : register(t1);
sampler masktexSampler : register(s1);

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
	float4 color;
	float4 maintexture = Tex0.Sample(Tex0Sampler,In.texCoord);
	
	if(
	(In.texCoord.x /  fPixelWidth < mask_x )
	|| (In.texCoord.x /  fPixelWidth >( mask_x + mask_width))
	|| (In.texCoord.y /  fPixelHeight < mask_y )
	|| (In.texCoord.y /  fPixelHeight >( mask_y + mask_height))
	)
	{
		color = maintexture;
	}
	else
	{
		float4 masktexture = masktex.Sample(masktexSampler,float2((In.texCoord.x/  fPixelWidth - mask_x)/mask_width,  (In.texCoord.y/  fPixelHeight - mask_y)/mask_height ));
	
		if(masktexture.r ==1 && masktexture.g ==1 && masktexture.b==1)
		{
			color = maintexture;
		}
		else
		{
			color = 0;
		}
	}
	
	if (PM)
		color.rgb *= color.a;
	
	return color * In.Tint;

}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}

