
// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float4	ambientLight;
	float	objX;
	float	objY;
	int		lightAenabled;
	float4	lightAColor;
	float	lightABrightness;
	float	lightAX;
	float	lightAY;
	float	lightAZ;

	int		lightBenabled;
	float4	lightBColor;
	float	lightBBrightness;
	float	lightBX;
	float	lightBY;
	float	lightBZ;

	int		lightCenabled;
	float4	lightCColor;
	float	lightCBrightness;
	float	lightCX;
	float	lightCY;
	float	lightCZ;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
	float4 normal = img.Sample(imgSampler, In.texCoord) * In.Tint;
	normal = float4(normal.x-0.5, normal.y-0.5, normal.z-0.5, normal.w);
	float4 background = bkd.Sample(bkdSampler, In.texCoord); //*0.67
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
		amount = saturate(dot(normal.xyz,dir));
		color.rgb += amount * lightABrightness * dist * lightAColor.rgb;
	}
	
	if(lightBenabled)
	{
		lightPos = float3((lightBX-objX)*fPixelWidth+0.5,(lightBY-objY)*fPixelHeight+0.5,lightBZ);
		dir = normalize(lightPos - pixelPos);
		dist = 1/length(lightPos - pixelPos);
		amount = saturate(dot(normal.xyz,dir));
		color.rgb += amount * lightBBrightness * dist * lightBColor.rgb;
	}
	
	if(lightCenabled)
	{
		lightPos = float3((lightCX-objX)*fPixelWidth+0.5,(lightCY-objY)*fPixelHeight+0.5,lightCZ);
		dir = normalize(lightPos - pixelPos);
		dist = 1/length(lightPos - pixelPos);
		amount = saturate(dot(normal.xyz,dir));
		color.rgb += amount * lightCBrightness * dist * lightCColor.rgb;
	}

	return (float4(ambientLight.rgb,0) + color * background);
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	float4 normal = Demultiply(img.Sample(imgSampler, In.texCoord) * In.Tint);
	normal = float4(normal.x-0.5, normal.y-0.5, normal.z-0.5, normal.w);
	float4 background = Demultiply(bkd.Sample(bkdSampler, In.texCoord));//*0.67
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
		amount = saturate(dot(normal.xyz,dir));
		color.rgb += amount * lightABrightness * dist * lightAColor.rgb;
	}
	
	if(lightBenabled)
	{
		lightPos = float3((lightBX-objX)*fPixelWidth+0.5,(lightBY-objY)*fPixelHeight+0.5,lightBZ);
		dir = normalize(lightPos - pixelPos);
		dist = 1/length(lightPos - pixelPos);
		amount = saturate(dot(normal.xyz,dir));
		color.rgb += amount * lightBBrightness * dist * lightBColor.rgb;
	}
	
	if(lightCenabled)
	{
		lightPos = float3((lightCX-objX)*fPixelWidth+0.5,(lightCY-objY)*fPixelHeight+0.5,lightCZ);
		dir = normalize(lightPos - pixelPos);
		dist = 1/length(lightPos - pixelPos);
		amount = saturate(dot(normal.xyz,dir));
		color.rgb += amount * lightCBrightness * dist * lightCColor.rgb;
	}

	float4 O = float4(ambientLight.rgb,0) + color * background;
	O.rgb *= O.a;
	return O;
}
