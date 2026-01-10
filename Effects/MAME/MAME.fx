
sampler2D img : register(s0);

float fWidth;
float fHeight;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{

float2 o = float2( 0.5 / fWidth, 0.5 / fHeight);
float2 i = 1.0 / texCoord;
float4 src = tex2D(img, i);
float4 N = tex2D(img, i + float2(    0,  o.y));
float4 E = tex2D(img, i + float2(  o.x,    0));
float4 S = tex2D(img, i + float2(    0, -o.y));
float4 W = tex2D(img, i + float2( -o.x,    0));
float2 p = texCoord * float2( fWidth, fHeight );
float4 output = src;
//p = p - floor(p);
//	if (p.x > 0.5) {
//		if (p.y > 0.5) {
//			output = all(N == E) && any(N != W) && any(E != S) ? E : src;
//		} else {
//			output = all(S == E) && any(W != S) && any(N != E) ? E : src;
//		}
//	} else {
//		if (p.y > 0.5) {
//			output = all(W == N) && any(N != E) && any(W != S) ? W : src;
//		} else {
//			output = all(W == S) && any(W != N) && any(S != E) ? W : src;
//		}
//	}
return output;	
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_a ps_main(); }  }