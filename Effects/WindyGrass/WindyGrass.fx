sampler2D img : register(s0) = sampler_state {
MinFilter = none;
MagFilter = none;
};

float intensity;
float time;
float timeCoef;
float opacity;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	In.x += ((In.y-0.9) * intensity)*sin((time*timeCoef)+(10*(cos(In.y)+3)));

	float4 Out = tex2D(img, In.xy);
	Out.a = lerp(0.0, Out.a, opacity);
	return Out;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }} 