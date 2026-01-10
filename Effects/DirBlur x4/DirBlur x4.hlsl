
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
	float fCoeff;
	float fAngle;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
  PS_OUTPUT Out;
  PS_OUTPUT OutA;
  PS_OUTPUT OutB;
  PS_OUTPUT OutC;
  PS_OUTPUT OutD;
  PS_OUTPUT OutE;
  PS_OUTPUT OutF;
  PS_OUTPUT OutG;
  PS_OUTPUT OutH;
	float _fAngle = fAngle*0.0174532925f;
	OutA.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+cos(_fAngle)*fCoeff,In.texCoord.y+sin(_fAngle)*fCoeff));
	OutB.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-cos(_fAngle)*fCoeff,In.texCoord.y-sin(_fAngle)*fCoeff));
	OutC.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+cos(_fAngle)*fCoeff*0.75,In.texCoord.y+sin(_fAngle)*fCoeff*0.75));
	OutD.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-cos(_fAngle)*fCoeff*0.75,In.texCoord.y-sin(_fAngle)*fCoeff*0.75));
	OutE.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+cos(_fAngle)*fCoeff*0.5,In.texCoord.y+sin(_fAngle)*fCoeff*0.5));
	OutF.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-cos(_fAngle)*fCoeff*0.5,In.texCoord.y-sin(_fAngle)*fCoeff*0.5));
	OutG.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+cos(fAngle)*fCoeff*0.25,In.texCoord.y+sin(fAngle)*fCoeff*0.25));
	OutH.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-cos(fAngle)*fCoeff*0.25,In.texCoord.y-sin(fAngle)*fCoeff*0.25));
	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord.xy);
	Out.Color = (Out.Color+OutA.Color+OutB.Color+OutC.Color+OutD.Color+OutE.Color+OutF.Color+OutG.Color+OutH.Color)/9;
	Out.Color *= In.Tint;
  return Out;
}

float4 GetColorPM(float2 xy)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
  PS_OUTPUT Out;
  PS_OUTPUT OutA;
  PS_OUTPUT OutB;
  PS_OUTPUT OutC;
  PS_OUTPUT OutD;
  PS_OUTPUT OutE;
  PS_OUTPUT OutF;
  PS_OUTPUT OutG;
  PS_OUTPUT OutH;
	float _fAngle = fAngle*0.0174532925f;
	OutA.Color = GetColorPM(float2(In.texCoord.x+cos(_fAngle)*fCoeff,In.texCoord.y+sin(_fAngle)*fCoeff));
	OutB.Color = GetColorPM(float2(In.texCoord.x-cos(_fAngle)*fCoeff,In.texCoord.y-sin(_fAngle)*fCoeff));
	OutC.Color = GetColorPM(float2(In.texCoord.x+cos(_fAngle)*fCoeff*0.75,In.texCoord.y+sin(_fAngle)*fCoeff*0.75));
	OutD.Color = GetColorPM(float2(In.texCoord.x-cos(_fAngle)*fCoeff*0.75,In.texCoord.y-sin(_fAngle)*fCoeff*0.75));
	OutE.Color = GetColorPM(float2(In.texCoord.x+cos(_fAngle)*fCoeff*0.5,In.texCoord.y+sin(_fAngle)*fCoeff*0.5));
	OutF.Color = GetColorPM(float2(In.texCoord.x-cos(_fAngle)*fCoeff*0.5,In.texCoord.y-sin(_fAngle)*fCoeff*0.5));
	OutG.Color = GetColorPM(float2(In.texCoord.x+cos(_fAngle)*fCoeff*0.25,In.texCoord.y+sin(_fAngle)*fCoeff*0.25));
	OutH.Color = GetColorPM(float2(In.texCoord.x-cos(_fAngle)*fCoeff*0.25,In.texCoord.y-sin(_fAngle)*fCoeff*0.25));
	Out.Color = GetColorPM(In.texCoord.xy);
	Out.Color = (Out.Color+OutA.Color+OutB.Color+OutC.Color+OutD.Color+OutE.Color+OutF.Color+OutG.Color+OutH.Color)/9;
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
  return Out;
}
