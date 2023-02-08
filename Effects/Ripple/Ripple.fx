
sampler2D Tex0 = sampler_state {MinFilter = Point; MagFilter = Point;};

float Step;
float Intensity;
float X, Y;

float fPixelWidth,fPixelHeight;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float w = X - In.x;
	float h = Y - In.y;
	float distanceFromCenter = sqrt(w * w + h * h);
	
	float sinArg = distanceFromCenter * 10.0 - Step * 4.0;
	float slope = cos(sinArg) * Intensity;
	float4 color = tex2D(Tex0, In.xy + normalize(float2(w, h)) * slope * 0.05);
	
	return color;
}


// Effect technique
technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader	= NULL;
		PixelShader		= compile ps_2_0 ps_main();
	}	
}