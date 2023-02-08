
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

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fA;
	float fX;
	float fY;
	float fSx;
	float fSy;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	In.texCoord.x -= fSx;
	In.texCoord.y -= fSy;
	float _fX = fX + 0.5f;
	float _fY = fY + 0.5f;
	float _fA = fA * 0.0174532925f;
	float Ray = sqrt(pow(In.texCoord.x-_fX,2)+pow(In.texCoord.y-_fY,2));
	float Angle;
	if(In.texCoord.y-_fY>0)
	{
		Angle = acos((In.texCoord.x-_fX)/Ray);
	}
	else
	{
		Angle = 0-acos((In.texCoord.x-_fX)/Ray);
	}
		
    In.texCoord.x = _fX + cos(Angle+_fA)*Ray;
    In.texCoord.y = _fY + sin(Angle+_fA)*Ray;
    if(In.texCoord.x >= 0 && In.texCoord.x <= 1 && In.texCoord.y >= 0 && In.texCoord.y <= 1)
    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord.xy);
    else Out.Color = float4(0,0,0,0);
	Out.Color *= In.Tint;
    return Out;
}
