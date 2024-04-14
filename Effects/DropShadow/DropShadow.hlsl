
Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

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

cbuffer PS_VARIABLES : register(b0)
{
	float x, y, xScale, yScale, xSkew, ySkew, xCenter, yCenter;
	float angle;
	float4 color;
	float alpha;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{ 
	//Source color
	float4 ret = Demultiply(Texture0.Sample(TextureSampler0, In.texCoord));

	//Center coord
	float _xCenter = xCenter * fPixelWidth;
	float _yCenter = yCenter * fPixelHeight;
	float2 center = float2(_xCenter, _yCenter);
	
	//Determine shadow pixel
	float2 pixel;
	if(angle)
	{
		float theta = angle/180.0*3.154159;
		float2 _point = float2(cos(theta)*x - sin(theta)*y, sin(theta)*x + cos(theta)*y);
		pixel = In.texCoord - float2(_point.x*fPixelWidth, _point.y*fPixelHeight);
	}
	//No angle, skip some calculations
	else
	{
		pixel = In.texCoord - float2(x*fPixelWidth, y*fPixelHeight);
	}
	
	//Apply skew
	pixel.x += xSkew * (In.texCoord.y - _yCenter);
	pixel.y += ySkew * (In.texCoord.x - _xCenter);
	
	//Apply scale
	pixel = (pixel-center) / float2(xScale, yScale) + center;

	//Exit if no shadow
	if(pixel.x < 0 || pixel.x > 1 || pixel.y < 0 || pixel.y > 1) {}
	else
	{
		float4 shadow = color;
		shadow.a = Texture0.Sample(TextureSampler0, pixel).a*alpha;
		//Thank, you Wikipedia. Thanks. *sniffs*
		float new_a = 1 - (1-ret.a) * (1-shadow.a);
		ret.rgb = (ret.rgb*ret.a + shadow.rgb*shadow.a*(1-ret.a)) / new_a;
		ret.a = new_a;
	}
	
	if (PM)
		ret.rgb *= ret.a;
		
	return ret * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}