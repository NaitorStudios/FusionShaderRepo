
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
	float fD;
	float fE;
	float fX;
	float fY;
	float fRatio;
	float fC;
	int iInvert;
	int iH;
	int iV;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint;
    if(iH==0 || (iH==1 && In.texCoord.x >fX) || (iH==2 && In.texCoord.x <fX) ) {
    	if(iV==0 || (iV==1 && In.texCoord.y >fY) || (iV==2 && In.texCoord.y <fY) ) {
		    float a = pow(max(0,min(1,sqrt(pow(In.texCoord.y-fY,2)/fRatio+pow(In.texCoord.x-fX,2)*fRatio)/fD)),fE)*fC;
		    if(iInvert==1) Out.Color.a *= 1-a;
		    else Out.Color.a *= a;
		  }
    }
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint;
    if(iH==0 || (iH==1 && In.texCoord.x >fX) || (iH==2 && In.texCoord.x <fX) )
	{
    	if(iV==0 || (iV==1 && In.texCoord.y >fY) || (iV==2 && In.texCoord.y <fY) )
		{
		    float a = pow(max(0,min(1,sqrt(pow(In.texCoord.y-fY,2)/fRatio+pow(In.texCoord.x-fX,2)*fRatio)/fD)),fE)*fC;
		    if(iInvert==1)
				Out.Color *= 1-a;
		    else
				Out.Color *= a;
		}
    }
    return Out;
}
