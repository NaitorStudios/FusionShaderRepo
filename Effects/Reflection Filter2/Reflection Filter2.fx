sampler2D bg : register(s1);
float fCoeff, fBlend;
int Mode;
float intensity;
float time;

int4 noise = {0,0,0,1};

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	if (In.y > 0.5) {
	In.x += ((In.y-0.5) * intensity)*sin(time+(10*cos(In.y)));
	}

	if (Mode == 1){
		if (In.y < fCoeff){
			In.y = (- In.y / fCoeff) + In.y + 1;
		}
	}
	else if (Mode == 2){
		if (In.x < fCoeff){
			In.x = (- In.x / fCoeff) + In.x + 1;
		}
	}
	else if (Mode == 3){
		if (In.x > fCoeff){
			In.x = ((In.x - 1) * fCoeff) / (fCoeff - 1);
		}
	}
	else {
		if (In.y > fCoeff){
			In.y = ((In.y - 1) * fCoeff) / (fCoeff - 1);
		}
	}

	return float4(tex2D(bg,In).rgb,1.0-fBlend);
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_a ps_main(); }} 