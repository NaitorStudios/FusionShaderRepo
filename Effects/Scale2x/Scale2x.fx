
sampler2D img : register(s0);

int fWidth;
int fHeight;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float2 o = float2( 0.5 / fWidth, 0.5 / fHeight);
float2 i = float2((floor(texCoord.x * fWidth * 0.5) + 0.5001) * (1.0 / fWidth), (floor(texCoord.y * fHeight * 0.5) + 0.5001) * (1.0 / fHeight));

float4 P = tex2D(img, i);
float4 N = tex2D(img, i + float2(    0, -o.y));
float4 E = tex2D(img, i + float2(  o.x,    0));
float4 S = tex2D(img, i + float2(    0,  o.y));
float4 W = tex2D(img, i + float2( -o.x,    0));

float4 PixNW = P;
float4 PixNE = P;
float4 PixSW = P;
float4 PixSE = P;

if (any(N != S) && any(E != W)) {
PixNW = all(N == W) ? N : P;
PixNE = all(N == E) ? N : P;
PixSW = all(S == W) ? S : P;
PixSE = all(S == E) ? S : P;
}

float4 output;

float2 subPixel = float2( floor((texCoord.x * fWidth) % 2.0) , floor((texCoord.y * fHeight) % 2.0) );
if (subPixel.x == 0) {
	if (subPixel.y == 0) {
	output = PixNW;
	//output = float4(1,0,0,1);
	} else {
	output = PixSW;
	//output = float4(0,1,0,1);
	}
} else {
	if (subPixel.y == 0) {
	output = PixNE;
	//output = float4(0,0,1,1);
	} else {
	output = PixSE;
	//output = float4(1,0,1,1);
	}
}
return output;

}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_a ps_main(); }  }