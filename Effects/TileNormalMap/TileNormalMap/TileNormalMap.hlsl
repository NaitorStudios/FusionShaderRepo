//If you try compiling this, you'll need to disable the warnings.

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

Texture2D<float4> Overlay : register(t1);
sampler OverlaySampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	int tilesetWidth, tilesetHeight, tileIndex;
	
	float4 ambientLight;
	float objX, objY;
	
	int lightAenabled;
	float4 lightAColor;
	float lightABrightness;
	float lightAX;
	float lightAY;
	float lightAZ;
	
	int lightBenabled;
	float4 lightBColor;
	float lightBBrightness;
	float lightBX;
	float lightBY;
	float lightBZ;
	
	int lightCenabled;
	float4 lightCColor;
	float lightCBrightness;
	float lightCX;
	float lightCY;
	float lightCZ;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float2 normalOut;
	normalOut.x = (1.0/float(tilesetWidth))*(float(tileIndex) % float(tilesetWidth))+ In.texCoord.x/float(tilesetWidth);
	normalOut.y = (1.0/float(tilesetHeight))*int(float(tileIndex) / float(tilesetWidth) + 0.001) + In.texCoord.y/float(tilesetHeight);

	float4 normal = Demultiply(Overlay.Sample(OverlaySampler, normalOut));
	normal = float4(normal.x-0.5, normal.y-0.5, normal.z-0.5, normal.w);
	float4 background = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord)) * In.Tint;
	float4 color = float4(0,0,0,normal.a);
	float3 pixelPos = float3(In.texCoord.xy,0);
	float3 objPos = float3(objX,objY,0);
	float3 lightPos, dir;
	float dist, amount;
	
	if(lightAenabled)
	{
		lightPos = float3((lightAX-objX)*fPixelWidth+0.5,(lightAY-objY)*fPixelHeight+0.5,lightAZ);
		dir = normalize(lightPos - pixelPos);
		dist = 1/length(lightPos - pixelPos);
		amount = saturate(dot(normal,dir));
		color.rgb += amount * lightABrightness * dist * lightAColor.rgb;
	}
	
	if(lightBenabled)
	{
		lightPos = float3((lightBX-objX)*fPixelWidth+0.5,(lightBY-objY)*fPixelHeight+0.5,lightBZ);
		dir = normalize(lightPos - pixelPos);
		dist = 1/length(lightPos - pixelPos);
		amount = saturate(dot(normal,dir));
		color.rgb += amount * lightBBrightness * dist * lightBColor.rgb;
	}
	
	if(lightCenabled)
	{
		lightPos = float3((lightCX-objX)*fPixelWidth+0.5,(lightCY-objY)*fPixelHeight+0.5,lightCZ);
		dir = normalize(lightPos - pixelPos);
		dist = 1/length(lightPos - pixelPos);
		amount = saturate(dot(normal,dir));
		color.rgb += amount * lightCBrightness * dist * lightCColor.rgb;
	}

	return float4(ambientLight.rgb,0) + color * background;
}


