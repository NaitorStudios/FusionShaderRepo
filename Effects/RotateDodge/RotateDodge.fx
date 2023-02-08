sampler2D img = sampler_state{
	AddressU = Border;
	AddressV = Border;
};
sampler2D bkd : register(s1);

float angle, x, y;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{

	float a = radians(-angle);
	float co = cos(a);
	float si = sin(a);

	float4 B = tex2D(bkd, In);

	In -= float2(x, y);
	float temp = In.x * co + In.y * si + x;
	In.y = In.y * co - In.x * si + y;
	In.x = temp;

	float4 L = tex2D(img,In);
	float4 O = L == 1.0 ? 1.0:saturate(B/(1.0-L));
	O.a = 1.0; // Apparently
	return O;
}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }