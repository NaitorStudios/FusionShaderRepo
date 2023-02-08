
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
	float x;
	float y;
	float angle;
	float4 color;
	float alpha;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float2 getshadowxy(float2 xy)
{
	float2 pixel;
	if(angle)
	{
		float theta = angle/180.0*3.154159;
		float2 pnt = float2(cos(theta)*x-sin(theta)*y,sin(theta)*x+cos(theta)*y);
		pixel = xy-float2(pnt.x*fPixelWidth,pnt.y*fPixelHeight);
	}
	//No angle, skip some calculations
	else
	{
		pixel = xy-float2(x*fPixelWidth,y*fPixelHeight);
	}
	return pixel;
}

float4 ps_main(PS_INPUT In) : SV_TARGET
{ 
	//Source color
	float4 ret = Texture0.Sample(TextureSampler0,In.texCoord) * In.Tint;
	
	//Determine shadow pixel
	float2 pixel = getshadowxy(In.texCoord);

	//Exit if no shadow
	if(pixel.x<0||pixel.x>1||pixel.y<0||pixel.y>1) {}
	else
	{
		float4 shadow = color;
		shadow.a = Texture0.Sample(TextureSampler0,pixel).a * In.Tint.a * alpha;
		//Thank, you Wikipedia. Thanks. *sniffs*
		float new_a = 1-(1-ret.a)*(1-shadow.a);
		ret.rgb = (ret.rgb*ret.a+shadow.rgb*shadow.a*(1-ret.a))/new_a;
		ret.a = new_a;
	}
	
	return ret;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{ 
	//Source color
	float4 ret = Texture0.Sample(TextureSampler0,In.texCoord) * In.Tint;
	
	//Determine shadow pixel
	float2 pixel = getshadowxy(In.texCoord);

	//Exit if no shadow
	if(pixel.x<0||pixel.x>1||pixel.y<0||pixel.y>1) {}
	else
	{
		float4 shadow = color;
		shadow.a = Texture0.Sample(TextureSampler0,pixel).a * In.Tint.a * alpha;
		//Thank, you Wikipedia. Thanks. *sniffs*
		float new_a = 1-(1-ret.a)*(1-shadow.a);
		ret.rgb = (ret.rgb+shadow.rgb*shadow.a*(1-ret.a));
		ret.a = new_a;
	}
	
	return ret;
}
