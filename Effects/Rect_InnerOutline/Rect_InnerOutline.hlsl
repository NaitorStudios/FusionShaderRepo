struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float oWidth, oHeight, bSize;
	float4 bColor;
	float bAlpha;
}

float4 Demultiply(float4 _color)
{
	float4 o = _color;
	if ( o.a != 0 )
		o.rgb /= o.a;
	return o;
}



float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	//Retrieve the current Pixel's RGBA Float4.
	float4 o = Demultiply(img.Sample(imgSampler,In.texCoord) * In.Tint);

	//Determine Displayed Pixel's position.
	float xFract = (In.texCoord.x * oWidth)%(oWidth - bSize);
	float yFract = (In.texCoord.y * oHeight)%(oHeight - bSize);

	// Border Process:
	if (xFract <= bSize || yFract <= bSize) 
	{ 
		//Alpha
		o = lerp(o, float4(bColor.rgb,1.0), bAlpha);
	}
	
	//Return Output
	return o;
}



float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	//Retrieve the current Pixel's RGBA Float4.
	float4 o = Demultiply(img.Sample(imgSampler,In.texCoord) * In.Tint);

	//Determine Displayed Pixel's position.
	float xFract = (In.texCoord.x * oWidth)%(oWidth - bSize);
	float yFract = (In.texCoord.y * oHeight)%(oHeight - bSize);

	// Border Process:
	if (xFract <= bSize || yFract <= bSize) 
	{ 
		//Alpha
		o = lerp(o, float4(bColor.rgb,1.0), bAlpha);
	}
	
	//Return Output
	o.rgb *= o.a;
	return o;
}