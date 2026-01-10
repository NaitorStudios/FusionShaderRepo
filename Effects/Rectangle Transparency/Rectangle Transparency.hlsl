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
	float Wsize, Hsize, oWsize, oHsize, iAlpha, oAlpha;
	bool iInvert, oInvert;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET {
	//Retrieve the current Pixel's RGBA Float4.
	float4 o = Demultiply(img.Sample(imgSampler,In.texCoord));
	o.a *= In.Tint.a;

	//Determine Displayed Pixel's position.
	float xFract = (In.texCoord.x * Wsize)%(Wsize - oWsize);
	float yFract = (In.texCoord.y * Hsize)%(Hsize - oHsize);

	//Process:
	//Inner Shape
	if (xFract <= oWsize || yFract <= oHsize) 
	{ 
		//Alpha
		o.a = o.a * oAlpha;

		//Invert RGB
		if (oInvert) {o.rgb = 1.0-o.rgb;}
	 }
	//Outer Shape
	else 
	{ 
		//Alpha
		o.a = o.a * iAlpha; 

		//Invert RGB
		if (iInvert) {o.rgb = 1.0-o.rgb;}
	}


	if (PM)
		o.rgb *= o.a;
	
	o.rgb *= In.Tint.rgb;
	return o;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}