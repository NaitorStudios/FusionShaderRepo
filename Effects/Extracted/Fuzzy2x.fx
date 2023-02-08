
sampler2D img : register(s0);

int fWidth;
int fHeight;
float blur;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float2 o = float2( 0.5 / fWidth, 0.5 / fHeight);
float2 i = float2((floor(texCoord.x * fWidth * 0.5) + 0.5) * (1.0 / fWidth), (floor(texCoord.y * fHeight * 0.5) + 0.5) * (1.0 / fHeight));

float4 P = tex2D(img, i);
float4 N = tex2D(img, i + float2(    0, -o.y));
float4 E = tex2D(img, i + float2(  o.x,    0));
float4 S = tex2D(img, i + float2(    0,  o.y));
float4 W = tex2D(img, i + float2( -o.x,    0));

float4 PixNW = (N + W + (P * blur)) / (blur+2);
float4 PixNE = (N + E + (P * blur)) / (blur+2);
float4 PixSW = (S + W + (P * blur)) / (blur+2);
float4 PixSE = (S + E + (P * blur)) / (blur+2);

float4 output;

float2 subPixel = float2( floor((texCoord.x * fWidth) % 2.0) , floor((texCoord.y * fHeight) % 2.0) );
if (subPixel.x == 0) {
	if (subPixel.y == 0) {
	output = PixNW;
	} else {
	output = PixSW;
	}
} else {
	if (subPixel.y == 0) {
	output = PixNE;
	} else {
	output = PixSE;
	}
}
return output;

}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_a ps_main(); }  }