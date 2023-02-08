// Created by Adam Hawker (aka Sketchy / MuddyMole)
// Free for personal or commercial use

sampler2D img : register(s0);
float Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Tx1, Tx2, Ty1, Ty2, Lx1, Lx2;

float4 ps_main(in float2 texCoord : texCoord0) : COLOR0	{

Dx += 0.0001;
float4 outColor = float4( 0, 0, 0, 0 );

float a = (Ax - texCoord.x) * (By - texCoord.y) - (Bx - texCoord.x) * (Ay - texCoord.y);
float b = (Bx - texCoord.x) * (Cy - texCoord.y) - (Cx - texCoord.x) * (By - texCoord.y);
float c = (Cx - texCoord.x) * (Dy - texCoord.y) - (Dx - texCoord.x) * (Cy - texCoord.y);
float d = (Dx - texCoord.x) * (Ay - texCoord.y) - (Ax - texCoord.x) * (Dy - texCoord.y);
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
float cl = Lx1 + (Lx2 - Lx1) * l;
outColor = tex2D(img, float2(l * (Tx2 - Tx1) + Tx1, m * (Ty2 - Ty1) + Ty1)) * float4(cl, cl, cl, 1);

}

return outColor;

}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }