sampler2D bg : register(s1);
float fCoeff, fAngle, Angle, Dist;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	Dist = distance(In.xy, float2(0.5,0.5)) * 2;
	if (Dist < 1.0){
		Angle = atan2(In.y - 0.5, In.x - 0.5) + pow(1 - Dist,2) * fAngle;
		Dist = (pow(Dist,fCoeff)) / 2;
		In.x = cos(Angle) * Dist + 0.5;
		In.y = sin(Angle) * Dist + 0.5;
	}
 	return tex2D(bg,In.xy);
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}