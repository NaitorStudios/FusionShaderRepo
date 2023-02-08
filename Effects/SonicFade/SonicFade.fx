sampler2D Texture0;
float time;
float4 a, b;

float STEP = 1/3.0;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{ 
	//Source color
	float4 ret = tex2D(Texture0, In);
	float3 fade = 1;

	//Step A: black to A
	if(time < STEP)
	{
		fade *= a.rgb * (time/STEP);
	}
	//Step B: A to B
	else if(time >= STEP && time <= 2*STEP)
	{
		fade = lerp(a.rgb, b.rgb, (time-STEP)/STEP);
	}
	//Step C: B to white
	else if(time < 1)
	{
		fade = 1 - (1-b)*((1-time)/STEP);
	}

	//Apply fade
	ret.rgb *= fade;
	return ret;
}

technique Shader { pass P0 { PixelShader = compile ps_2_0 ps_main(); } }