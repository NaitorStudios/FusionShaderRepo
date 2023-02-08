
// Global variables
sampler2D img;
sampler2D bkd : register(s1);

int lightAenabled, lightBenabled, lightCenabled;
float4 lightAColor, lightBColor, lightCColor, ambientLight;

float fPixelWidth;
float fPixelHeight;

float lightAX, lightBX, lightCX;
float lightAY, lightBY, lightCY;
float lightAZ, lightBZ, lightCZ;
float lightABrightness, lightBBrightness, lightCBrightness;

float objX, objY;

float4 ps_main( in float2 texCoord : TEXCOORD ) : COLOR
{
	float4 normal = tex2D(img, texCoord);
	normal = float4(normal.x-0.5, normal.y-0.5, normal.z-0.5, normal.w);
	float4 background = tex2D(bkd, texCoord);
	float4 color = float4(0,0,0,normal.a);
	float3 pixelPos = float3(texCoord.xy,0);
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

// Effect technique
technique tech_main {pass P0{PixelShader = compile ps_2_0 ps_main();}}