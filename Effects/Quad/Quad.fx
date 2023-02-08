// Created by Adam Hawker (aka Sketchy / MuddyMole)
// Free for personal or commercial use

sampler2D img : register(s0);

float xA;
float yA;
float xB;
float yB;
float xC;
float yC;
float xD;
float yD;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

xD += 0.0001;
float4 getColor = float4( 0, 0, 0, 0 );

float a = (xA - texCoord.x) * (yB - texCoord.y) - (xB - texCoord.x) * (yA - texCoord.y);
float b = (xB - texCoord.x) * (yC - texCoord.y) - (xC - texCoord.x) * (yB - texCoord.y);
float c = (xC - texCoord.x) * (yD - texCoord.y) - (xD - texCoord.x) * (yC - texCoord.y);
float d = (xD - texCoord.x) * (yA - texCoord.y) - (xA - texCoord.x) * (yD - texCoord.y);
if (sign(a) == sign(b) && sign(b) == sign(c) && sign(c) == sign(d)) {

float a1 = xA;
float a2 = xB - xA;
float a3 = xD - xA;
float a4 = xA - xB + xC - xD;

float b1 = yA;
float b2 = yB - yA;
float b3 = yD - yA;
float b4 = yA - yB + yC - yD;

float aa = a4*b3 - a3*b4;
float bb = a4*b1 -a1*b4 + a2*b3 - a3*b2 + texCoord.x*b4 - texCoord.y*a4;
float cc = a2*b1 -a1*b2 + texCoord.x*b2 - texCoord.y*a2;
float det = sqrt(bb*bb - 4*aa*cc);

float m = (-bb+det)/(2*aa);
float l = (texCoord.x-a1-a3*m)/(a2+a4*m);

getColor = tex2D(img, float2( l, m ));

}

return getColor;

}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }