
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
Texture2D<float4> Texture0 : register(t0);
sampler Texture0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fC = 1;
	float fP = 5;
	float fX = 0.5;
	float fY = 0.5;
	float fPow = 1;
	int iRem = 0;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
   // Output pixel
   PS_OUTPUT Out;
   float _fX = 1-fX; 
   float _fY = 1-fY;
   //float dist = pow(fP,pow(sqrt(pow(_fX-In.texCoord.x,2)+pow(_fY-In.texCoord.y,2)),fPow));
   float dist = pow(abs(fP),pow(sqrt(pow(_fX-In.texCoord.x,2)+pow(_fY-In.texCoord.y,2)),fPow));
   float _fC = fC + (fP-1)*0.5; //Adjust zoom automaticly
   _fC *= 1+(1-dist);
   _fC = max(0,_fC);
   In.texCoord.x = In.texCoord.x + _fX*(_fC-1.0f);
   In.texCoord.y = In.texCoord.y + _fY*(_fC-1.0f);
   Out.Color = Texture0.Sample(Texture0Sampler, float2(In.texCoord.x/_fC,In.texCoord.y/_fC));
   if(iRem == 1 && (In.texCoord.x/_fC < 0 || In.texCoord.x/_fC > 1 || In.texCoord.y/_fC < 0 || In.texCoord.y/_fC > 1)) Out.Color = 0;
	Out.Color *= In.Tint;
    return Out;
}
