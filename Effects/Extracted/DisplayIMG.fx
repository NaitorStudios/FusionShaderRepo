// Global variables
sampler2D fg;
sampler2D bg : register(s1);
float R;
float G;
float B;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 src = tex2D(fg,In);
	float3 inv = src.rgb;
	float4 bck = tex2D(bg,In);
	if(bck.r==R/255 && bck.g==G/255 && bck.b==B/255 )
	{
		bck=src;
	}
	return bck;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}