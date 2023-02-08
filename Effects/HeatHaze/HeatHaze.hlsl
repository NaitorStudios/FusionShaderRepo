struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

Texture2D<float4> sBaseTexture : register(t0);
sampler sBaseTextureSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float uInvTexelWidth;
	float uInvTexelHeight;
	float uPhase;
	float uScale;
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float2 phs = float2( cos( uPhase + ( In.texCoord.y * uScale ) ), sin( uPhase + ( In.texCoord.x * uScale ) ) );
    float2 crd = In.texCoord + ( phs * float2( uInvTexelWidth, uInvTexelHeight ) );
    float2 btr = float2( uInvTexelWidth * 5.0, uInvTexelHeight * 5.0 );
    Out.Color = Demultiply(sBaseTexture.Sample( sBaseTextureSampler, clamp( crd, btr, float2( 1.0, 1.0 ) - btr ) )) * In.Tint;
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    PS_OUTPUT Out;
    float2 phs = float2( cos( uPhase + ( In.texCoord.y * uScale ) ), sin( uPhase + ( In.texCoord.x * uScale ) ) );
    float2 crd = In.texCoord + ( phs * float2( uInvTexelWidth, uInvTexelHeight ) );
    float2 btr = float2( uInvTexelWidth * 5.0, uInvTexelHeight * 5.0 );
    Out.Color = Demultiply(sBaseTexture.Sample( sBaseTextureSampler, clamp( crd, btr, float2( 1.0, 1.0 ) - btr ) )) * In.Tint;
	Out.Color.rgb *= Out.Color.a;
    return Out;
}


