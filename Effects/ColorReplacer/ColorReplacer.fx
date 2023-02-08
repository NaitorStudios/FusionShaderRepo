sampler2D img;

const float HALF = 128.0/255;
float4 R, G, B, C, M, Y, T, P, O;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 o = tex2D(img,In);
	
	if(o.r == 1)
	{
		if(o.g == 1)
		{
			if(o.b == 0)
				o.rgb = Y.rgb;
		}
		else if(o.g == 0)
		{
			if(o.b == 1)
				o.rgb = M.rgb;
			else if(o.b == 0)
				o.rgb = R.rgb;
		}
	}
	else if(o.r == 0)
	{
		if(o.g == 1)
		{
			if(o.b == 1)
				o.rgb = C.rgb;
			else if(o.b == 0)
				o.rgb = G.rgb;
		}
		else if(o.g == 0)
		{
			if(o.b == 1)
				o.rgb = B.rgb;
		}
		else if(o.g == HALF && o.b == HALF)
		{
			o.rgb = T.rgb;
		}
	}
	else if(o.r == HALF)
	{	
		if(o.g == 0 && o.b == HALF)
		{
			o.rgb = P.rgb;
		}	
		else if(o.g == HALF && o.b == 0)
		{
			o.rgb = O.rgb;
		}
	}
	
	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}