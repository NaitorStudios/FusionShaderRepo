struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s2);

Texture2D<float4> bg : register(t1);
sampler bgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float width;
	float height;
	float xoff;
	float yoff;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 GetColorPM(float2 xy)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}


PS_OUTPUT ps_main( in PS_INPUT In )
{
	PS_OUTPUT Out;
		float4 shift = GetColorPM(In.texCoord);
		float scalar = shift.b;
		float2 shiftcoor = float2(fmod(In.texCoord.x + xoff*fPixelWidth,1),fmod(In.texCoord.y + yoff*fPixelHeight,1));
		shift = GetColorPM(shiftcoor);
		float2 off = float2(width*fPixelWidth,height*fPixelHeight);
		off.x = off.x*2*(shift.r-0.5) * scalar;
		off.y = off.y*2*(shift.g-0.5) * scalar;
		if (In.texCoord.x+off.x < 0 || In.texCoord.x+off.x > 1 || In.texCoord.y+off.y < 0 || In.texCoord.y+off.y > 1){
			Out.Color = bg.Sample(bgSampler,In.texCoord);
		} else {
			Out.Color = bg.Sample(bgSampler,In.texCoord + off);
		}
	Out.Color.a = shift.a;
	return Out;
}