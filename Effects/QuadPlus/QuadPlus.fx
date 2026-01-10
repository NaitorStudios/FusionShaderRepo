// Created by Adam Hawker (aka Sketchy / MuddyMole)
// Free for personal or commercial use

sampler2D img : register(s0);
float Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, vax, vay, vbx, vby, vcx, vcy, vdx, vdy, Tx1, Tx2, Ty1, Ty2;

float4 ps_main(in float2 texCoord : texCoord0) : COLOR0	{

vdx += 0.0001;
vdy += 0.0001;
Dx += 0.0001;
float4 outColor = float4( 0, 0, 0, 0 );

float a = (vax - texCoord.x) * (vby - texCoord.y) - (vbx - texCoord.x) * (vay - texCoord.y);
float b = (vbx - texCoord.x) * (vcy - texCoord.y) - (vcx - texCoord.x) * (vby - texCoord.y);
float c = (vcx - texCoord.x) * (vdy - texCoord.y) - (vdx - texCoord.x) * (vcy - texCoord.y);
float d = (vdx - texCoord.x) * (vay - texCoord.y) - (vax - texCoord.x) * (vdy - texCoord.y);
if (sign(a) == sign(b) && sign(b) == sign(c) && sign(c) == sign(d)) {

float a2 = Bx - Ax;
float a3 = Dx - Ax;
float a4 = Ax - Bx + Cx - Dx;

float b2 = By - Ay;
float b3 = Dy - Ay;
float b4 = Ay - By + Cy - Dy;

float aa = a4 * b3 - a3 * b4;
float bb = a4 * Ay - Ax * b4 + a2 * b3 - a3 * b2 + texCoord.x * b4 - texCoord.y * a4;
float cc = a2 * Ay - Ax * b2 + texCoord.x * b2 - texCoord.y * a2;

float m = (-bb + sqrt(bb * bb - 4 * aa * cc)) / (2 * aa);
float l = (texCoord.x - Ax - a3 * m) / (a2 + a4 * m);
outColor = tex2D(img, float2(l * (Tx2 - Tx1) + Tx1, m * (Ty2 - Ty1) + Ty1)) ;

}

return outColor;

}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }