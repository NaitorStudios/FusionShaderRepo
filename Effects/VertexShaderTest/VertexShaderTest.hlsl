struct VS_INPUT
{
    float4 Position : POSITION;
    float2 texCoord : TEXCOORD0;
};

struct VS_OUTPUT
{
    float4 Position : POSITION;
    float2 texCoord : TEXCOORD0;
};

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


Texture2D<float4> sBaseTexture : register(t0);
sampler sBaseTextureSampler : register(s0);

cbuffer PS_VARIABLES:register(b0)
{
	float uCamX;
	float uCamY;
	float uCamWidth;
	float uCamHeight;
	float uCamNear;
	float uCamFar;
	
	float uSkewHor;
	float uSkewVert;
}

cbuffer PS_PIXELSIZE : register(b1) {
	float fPixelWidth;
	float fPixelHeight;
};


float4x4 buildOrthoMatrix( float left, float right, float bottom, float top, float near, float far )
{
    return float4x4(
        float4( 2.0 / ( right - left ), 0.0, 0.0, 0.0 ),
        float4( 0, 2.0 / ( top - bottom ), 0.0, 0.0 ),
        float4( 0.0, 0.0, 1.0 / ( far - near ), 0.0 ),
        float4( ( left + right ) / ( left - right ), ( top + bottom ) / ( bottom - top ), near / ( near - far ), 1.0 )
    );
}

float4x4 buildCenterOrthoMatrix( float2 pos, float2 size, float2 zNearFar )
{
    return buildOrthoMatrix( pos.x - size.x * 0.5, pos.x + size.x * 0.5, pos.y + size.y * 0.5, pos.y - size.y * 0.5, zNearFar.x, zNearFar.y );
}

VS_OUTPUT vs_main( const VS_INPUT In )
{
    VS_OUTPUT Out;
    float4 off = float4( In.texCoord.x - 0.5, In.texCoord.y - 0.5, 0.0, 0.0 );
    off += float4( off.x * off.y * uSkewHor, off.y * off.x * uSkewVert, 0.0, 0.0 );
    float4x4 proj = buildCenterOrthoMatrix( float2( uCamX, uCamY ), float2( uCamWidth, uCamHeight ), float2( uCamNear, uCamFar ) );
    Out.Position = mul( In.Position + off, proj );
    Out.texCoord = In.texCoord;
    return Out;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    PS_OUTPUT Out;
    Out.Color = sBaseTexture.Sample( sBaseTextureSampler, In.texCoord );
    return Out;
}

