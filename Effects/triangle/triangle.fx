// Based on this: http://www.blackpawn.com/texts/pointinpoly/

float Ax;
float Ay;
float Bx;
float By;
float Cx;
float Cy;
float4 drawColor;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float2 A = float2(Ax, Ay);
float2 B = float2(Bx, By);
float2 C = float2(Cx, Cy);

float2 v0 = C - A;
float2 v1 = B - A;
float2 v2 = texCoord - A;

float dot00 = dot(v0, v0);
float dot01 = dot(v0, v1);
float dot02 = dot(v0, v2);
float dot11 = dot(v1, v1);
float dot12 = dot(v1, v2);

float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

float4 newColor = float4(0,0,0,0);

if ((u >= 0) && (v >= 0) && (u + v < 1)) {
newColor = drawColor;
}

return newColor;

}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
