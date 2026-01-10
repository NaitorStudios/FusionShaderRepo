 
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};


// Global variables
uniform sampler2D normalMap;
uniform sampler2D diffuseMap;
uniform sampler2D depthMap;
uniform sampler2D specularMap;
uniform sampler2D emissiveMap;
uniform sampler2D aoMap;
uniform sampler2D anisotropyMap;
uniform sampler2D indexMap;
uniform sampler2D paletteMap;

uniform float lightX, lightY, lightZ;
//uniform float3 lightPosition;
uniform float3 directLightColor;
uniform float3 ambientLightColor;
uniform float3 ambientLightColor2;
uniform float2 textureResolution;

uniform float celShadingLevel;

uniform float lightWrap;

uniform float amplifyDepth;

uniform float shadows;

uniform float ambientMapStrength;

uniform float normalFlip;

uniform float attenuationMultiplier;


uniform float2 rotationMatrix;

float4 ps_main(float2 texCoord : TEXCOORD) : COLOR
{

	float3 lightPosition = float3(lightX, lightY, lightZ);
	float2 centredTexCoords = texCoord;
	centredTexCoords *= textureResolution.xy;
	centredTexCoords = floor(centredTexCoords.xy) + float2(0.5, 0.5);
	centredTexCoords /= textureResolution.xy;

	float4 normalColor = tex2D(normalMap, texCoord);
	float4 diffuseColor = tex2D(diffuseMap, texCoord);
	float4 specularColor = tex2D(specularMap, texCoord);
	float4 emissiveColor = tex2D(emissiveMap, texCoord);
	float4 aoColor = tex2D(aoMap, texCoord);
	float4 anisotropyColor = tex2D(anisotropyMap, texCoord);
	float indexValue = tex2D(indexMap, texCoord).x;
	
	float depthColor = tex2D(depthMap, texCoord).x;
		
		
	if (diffuseColor.a <= 0.1)
	{
		discard;
	}
	
	aoColor *= ambientMapStrength;
	aoColor += 1.0 - ambientMapStrength;
	
	float sizeOfThing = 1.0;
	
	float3 fragPos = float3(0,0,0);
	fragPos.xy = texCoord.xy;
	
	
	fragPos.xy *= textureResolution.xy;
	fragPos.xy = floor(fragPos.xy);
	fragPos.xy /= textureResolution.xy;
	
	
	fragPos.y = 1.0 - fragPos.y;
	
	fragPos = fragPos + float3(-0.5, -0.5, 0);
	fragPos *= sizeOfThing * 2.0;
	fragPos.x *= (textureResolution.x / textureResolution.y);
	
	fragPos.z = depthColor * amplifyDepth;
	
	//fragPos.xy *= rotationMatrix;
	
	float3 normal = (normalColor.rgb - 0.5) * 2.0;
	normal.y *= normalFlip;
	//normal.xy *= rotationMatrix;
	
	
	
	
	
	float3 lightVec = lightPosition - fragPos;
	
	float lightDistance = length(lightVec) * attenuationMultiplier;
	
	float attenuation = 1.0 / (1.0 + 20.0 * lightDistance + 200.0 * lightDistance * lightDistance);
	
	normal = normalize(normal);
	lightVec = normalize(lightVec);
	float shadowMult = 1.0;
	if (shadows > 0.5)
	{
		float thisHeight = fragPos.z;
		float3 tapPos = float3(centredTexCoords, fragPos.z + 0.01);
		float3 moveVec = lightVec.xyz * float3(1.0, -1.0, 1.0) * 0.006;
		moveVec.xy *= rotationMatrix;
		moveVec.x *= textureResolution.y / textureResolution.x;
		for (int i = 0; i < 20; i++)
		{
			tapPos += moveVec;
			float tapDepth = tex2D(depthMap, tapPos.xy).x * amplifyDepth;
			if (tapDepth > tapPos.z)
			{
				shadowMult -= 0.125;
			}
		}
	}
	
	shadowMult = clamp(shadowMult, 0.0, 1.0);
	float rawDiffuse = clamp(dot(normal, lightVec) * 1000.0, 0.0, 1.0);
		
	float diffuseLevel = clamp(dot(normal, lightVec) + lightWrap, 0.0, lightWrap + 1.0) / (lightWrap + 1.0) * attenuation;
	
	
	
	
	//Specular calculations
	float3 viewVec = float3(0.0, 0.0, 1.0);	//Orthographic camera makes this nice and simple.
	float3 bounceVec = reflect(-lightVec, normal);
	float glossiness = 5.0;
	float specLevel = pow(clamp(dot(bounceVec, viewVec), 0.0, 1.0), glossiness) * rawDiffuse * 0.5 * attenuation * specularColor.r;
	
	
	diffuseLevel *= shadowMult;
	//For reasons I haven't yet figured out, a result of zero here gives a colour lookup of black, regardless of
	//the pallette. Hence the +0.01 on the end. Hopefully a less hacky solution will be found.
	float illumination = diffuseLevel + specLevel + 0.01;	
	illumination /= 2.0;

	return float4(tex2D(paletteMap, float2(indexValue, 1.0 - illumination)).rgb, diffuseColor.a);
	
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }  
}