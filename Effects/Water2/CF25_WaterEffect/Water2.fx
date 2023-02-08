struct PS_INPUT
{
    float4 Position : POSITION;
    float2 TexCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

sampler2D sBaseTexture;
float fPixelWidth;
float fPixelHeight;
sampler2D sNormalMap : register( s1 );
sampler2D sReflectionMap : register( s2 );
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

const float3 cEye = float3( 0.0, 0.0, 1.0 );


PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
	
    float2 coordNormalMap = frac( ( In.TexCoord + float2( uNormalsOffsetX, uNormalsOffsetY ) ) * float2( uNormalMapScaleX, uNormalMapScaleY ) );
    float3 normal = ( tex2D( sNormalMap, coordNormalMap ).xyz * (float3)2.0 ) - (float3)1.0;
    float3 tmp = float3( normal.xy, 0.0 );
    normal.z = sqrt( 1.0 - dot( tmp, tmp ) );
    float2 coordBase = clamp( In.TexCoord + ( normal.xy *  float2( uRefractSizeX, uRefractSizeY ) ), (float2)0.0, (float2)1.0 );
    float2 coordReflectionMap = clamp( In.TexCoord + ( normal.xy  * float2( uRefractSizeX, uRefractSizeY ) * float2( uReflectionMapScaleX, uReflectionMapScaleY ) ), (float2)0.0, (float2)1.0 );
    float4 col = tex2D( sBaseTexture, coordBase );
    float4 ref = tex2D( sReflectionMap, coordReflectionMap );
    float3 source = lerp( col.xyz, ref.xyz, uReflectionFactor );
    float3 light = normalize( float3( uLightX, uLightY, uLightZ ) + cEye );
    float specular = pow( abs( dot( light, normal ) ), uShine ) + uSpecular;
	
    Out.Color = float4( source + (float3)specular, col.w * uWaterAlpha );
	float alpha = tex2D( sBaseTexture, In.TexCoord ).a;
	Out.Color.a = lerp(0, Out.Color.a,alpha*2);

    return Out;
}

technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }
}