sampler2D img;

float4 fC;
float fT;
int iE;

float fPixelWidth, fPixelHeight;

static const float2 S[] = {
-1.0, 0.0,
0.0, -1.0,
0.0, 1.0,
1.0, 0.0,
-1.0, -1.0,
1.0, -1.0,
1.0, 1.0,
-1.0, 1.0
};

float4 PS(in float2 Coord : TEXCOORD0) : COLOR0
{
	float2 PSize = float2(fPixelWidth, fPixelHeight);
	float4 tex = tex2D(img,Coord);
	float line = 0.0;
	
	for(int i=0; i<4+4*iE; i++)
	{
		line = max(line,tex2D(img, Coord+PSize*fT*S[i]).a);
		line = max(line,tex2D(img, Coord+PSize*fT*S[i]).a);
	}
	line = line - tex.a;
	return lerp(tex,fC,line);
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 PS(); }  }
