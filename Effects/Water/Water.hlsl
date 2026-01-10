
// Global variables
Texture2D<float4> sBaseTexture : register(t0);
sampler sBaseTextureSampler : register(s0);

Texture2D<float4> sNormalMap : register(t1);
sampler sNormalMapSampler : register(s1);

Texture2D<float4> sReflectionMap : register(t2);
sampler sReflectionMapSampler : register(s2);



cbuffer PS_VARIABLES : register(b0)
{
float uNormalsOffsetX;
float uNormalsOffsetY;
float uRefractSizeX;
float uRefractSizeY;

float uReflectionFactor;
float uSpecular;
float uShine;
float uWaterAlpha;

float uLightX;
float uLightY;
float uLightZ;

float uNormalMapScaleX;
float uNormalMapScaleY;
float uReflectionMapScaleX;
float uReflectionMapScaleY;

static const float3 cEye = float3( 0.0, 0.0, 1.0 );
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

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};






PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	
	
	
	
	//float4 normal = img.Sample(imgSampler, In.texCoord) * In.Tint;
	
    float2 coordNormalMap = frac( ( In.texCoord + float2( uNormalsOffsetX, uNormalsOffsetY ) ) * float2( uNormalMapScaleX, uNormalMapScaleY ) );
	
    float3 normal = ( sNormalMap.Sample( sNormalMapSampler, coordNormalMap ).xyz * (float3)2.0 ) - (float3)1.0;
	
    float3 tmp = float3( normal.xy, 0.0 );
    normal.z = sqrt( 1.0 - dot( tmp, tmp ) );
	
    float2 coordBase = clamp( In.texCoord + ( normal.xy *  float2( uRefractSizeX, uRefractSizeY ) ), (float2)0.0, (float2)1.0 );
    float2 coordReflectionMap = clamp( In.texCoord + ( normal.xy * float2( uRefractSizeX, uRefractSizeY ) * float2( uReflectionMapScaleX, uReflectionMapScaleY ) ), (float2)0.0, (float2)1.0 );
	
    float4 col = sBaseTexture.Sample( sBaseTextureSampler, coordBase );
    float4 ref = sReflectionMap.Sample( sReflectionMapSampler, coordReflectionMap );
	
    float3 source = lerp( col.xyz, ref.xyz, uReflectionFactor );
	
    float3 light = normalize( float3( uLightX, uLightY, uLightZ ) + cEye );
	
    float specular = pow( abs( dot( light, normal ) ), uShine ) + uSpecular;
	
    Out.Color = float4( source + (float3)specular, col.w * uWaterAlpha );
	
    return Out;
}




float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{

    PS_OUTPUT Out;
	
    float2 coordNormalMap = frac( ( In.texCoord + float2( uNormalsOffsetX, uNormalsOffsetY ) ) * float2( uNormalMapScaleX, uNormalMapScaleY ) );
	
    float3 normal = ( sNormalMap.Sample( sNormalMapSampler, coordNormalMap ).xyz * (float3)2.0 ) - (float3)1.0;
	
    float3 tmp = float3( normal.xy, 0.0 );
    normal.z = sqrt( 1.0 - dot( tmp, tmp ) );
	
    float2 coordBase = clamp( In.texCoord + ( normal.xy *  float2( uRefractSizeX, uRefractSizeY ) ), (float2)0.0, (float2)1.0 );
    float2 coordReflectionMap = clamp( In.texCoord + ( normal.xy * float2( uRefractSizeX, uRefractSizeY ) * float2( uReflectionMapScaleX, uReflectionMapScaleY ) ), (float2)0.0, (float2)1.0 );
	
    float4 col = Demultiply(sBaseTexture.Sample( sBaseTextureSampler, coordBase ) * In.Tint);
    float4 ref = sReflectionMap.Sample( sReflectionMapSampler, coordReflectionMap );
	
    float3 source = lerp( col.xyz, ref.xyz, uReflectionFactor );
	
    float3 light = normalize( float3( uLightX, uLightY, uLightZ ) + cEye );
	
    float specular = pow( abs( dot( light, normal ) ), uShine ) + uSpecular;
	
    Out.Color = float4( source + (float3)specular, col.w * uWaterAlpha );
	Out.Color.rgb *= Out.Color.a;
    return Out;

}