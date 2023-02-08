// Created by Adam Hawker (aka Sketchy / MuddyMole)
// Free for personal or commercial use

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
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float xA;
	float yA;
	float xB;
	float yB;
	float xC;
	float yC;
	float xD;
	float yD;
};

float4 GetColorPM(float2 xy)
{
	float4 color = img.Sample(imgSampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{

float xDD = xD + 0.0001;
PS_OUTPUT Out;
Out.Color = float4(0,0,0,0);

float a2 = xB - xA;
float a3 = xDD - xA;
float a4 = xA - xB + xC - xDD;

float b2 = yB - yA;
float b3 = yD - yA;
float b4 = yA - yB + yC - yD;

float aa = a4*b3 - a3*b4;
float bb = a4*yA -xA*b4 + a2*b3 - a3*b2 + In.texCoord.x*b4 - In.texCoord.y*a4;
float cc = a2*yA -xA*b2 + In.texCoord.x*b2 - In.texCoord.y*a2;
float det = sqrt(bb*bb - 4*aa*cc);
float m = (-bb+det)/(2*aa);
float2 coord = float2( (In.texCoord.x-xA-a3*m)/(a2+a4*m), m );
if (coord.x > 0 && coord.x < 1 && coord.y > 0 && coord.y < 1){
	Out.Color = img.Sample(imgSampler,coord) * In.Tint;
} else {
	Out.Color = float4(0,0,0,0);
};

return Out;

}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{

float xDD = xD + 0.0001;
PS_OUTPUT Out;
Out.Color = float4(0,0,0,0);

float a2 = xB - xA;
float a3 = xDD - xA;
float a4 = xA - xB + xC - xDD;

float b2 = yB - yA;
float b3 = yD - yA;
float b4 = yA - yB + yC - yD;

float aa = a4*b3 - a3*b4;
float bb = a4*yA -xA*b4 + a2*b3 - a3*b2 + In.texCoord.x*b4 - In.texCoord.y*a4;
float cc = a2*yA -xA*b2 + In.texCoord.x*b2 - In.texCoord.y*a2;
float det = sqrt(bb*bb - 4*aa*cc);
float m = (-bb+det)/(2*aa);
float2 coord = float2( (In.texCoord.x-xA-a3*m)/(a2+a4*m), m );
if (coord.x > 0 && coord.x < 1 && coord.y > 0 && coord.y < 1){
	Out.Color = GetColorPM(coord);
	Out.Color.rgb *= Out.Color.a;
} else {
	Out.Color = float4(0,0,0,0);
};
Out.Color *= In.Tint;
return Out;

}