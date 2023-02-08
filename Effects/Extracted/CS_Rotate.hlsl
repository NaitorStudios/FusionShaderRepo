
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
	float fAngle;
	float fX;
	float fY;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	float _fAngle = fAngle*0.0174532925f;
	
    //In.texCoord.x = In.texCoord.x + fX*(fWidth-1.0f);
	//In.texCoord.y = In.texCoord.y + fY*(fHeight-1.0f);
	float Ray = sqrt(pow(In.texCoord.x-fX,2)+pow(In.texCoord.y-fY,2));
	float Angle;
	if(In.texCoord.y-fY>0)
	{
		Angle = acos((In.texCoord.x-fX)/Ray);
	}
	else
	{
		Angle = 0-acos((In.texCoord.x-fX)/Ray);
	}
		
    In.texCoord.x = fX + cos(Angle+_fAngle)*Ray;
    In.texCoord.y = fY + sin(Angle+_fAngle)*Ray;
   	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord.xy);
	Out.Color *= In.Tint;
	
    return Out;
}

