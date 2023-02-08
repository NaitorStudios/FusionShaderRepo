
sampler2D img : register(s0);

float fAx;
float fAy;
float fBx;
float fBy;
float fCx;
float fCy;
float fDx;
float fDy;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float inX = texCoord.x;
float inY = texCoord.y;
float topY = (((fBy - fAy) / (fBx - fAx)) * inX) + (fAy - (((fBy - fAy) / (fBx - fAx)) * fAx));
float bottomY = (((fCy - fDy) / (fCx - fDx)) * inX) + (fDy - (((fCy - fDy) / (fCx - fDx)) * fDx));
float leftX = (inY-(fAy - (((fDy - fAy) / (fDx - fAx)) * fAx))) / ((fDy - fAy) / (fDx - fAx));
float rightX = (inY-(fBy - (((fCy - fBy) / (fCx - fBx)) * fBx))) / ((fCy - fBy) / (fCx - fBx));

float C = (fAy - inY) * (fDx - inX) - (fAx - inX) * (fDy - inY);
float B = (fAy - inY) * (fCx - fDx) + (fBy - fAy) * (fDx - inX) - (fAx - inX) * (fCy - fDy) - (fBx - fAx) * (fDy - inY);
float A = (fBy - fAy) * (fCx - fDx) - (fBx - fAx) * (fCy - fDy);
float u = (-B - sqrt(B * B - 4 * A * C)) / (2 * A);
float p1x = fAx + (fBx - fAx) * u;
float v = (inX - p1x) / ((fDx + (fCx - fDx) * u) - p1x);

float4 getColor = tex2D(img, float2(u,v));
if ( v<0 || v>1 || (inX < leftX && fAx != fDx) || (inX > rightX && fBx != fCx) || (inX < fAx && fAx == fDx) || (inX > fBx && fBx == fCx)) {
	getColor.a = 0;
	}
return getColor;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }