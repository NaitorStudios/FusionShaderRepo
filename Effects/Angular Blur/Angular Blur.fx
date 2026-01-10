sampler2D img : register(s0);
sampler2D bg : register(s1) = sampler_state {addressU = clamp; addressV = clamp;};

//dx9 uses less samples due to it's limits
#define samples 16

bool BG;
float intensity;
float angle;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 { 
	float4 col = 0;
	float _angle = angle*0.0174532925f;

	for(float i=0; i<samples;i++){
		float2 uv = In + float2(cos(_angle)*intensity*(i/samples-0.5),sin(_angle)*intensity*(i/samples-0.5));

		if(BG) col += tex2D(bg, uv);
		else col += tex2D(img, uv);
	}

	col /= samples;
	return col;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_a ps_main(); } }