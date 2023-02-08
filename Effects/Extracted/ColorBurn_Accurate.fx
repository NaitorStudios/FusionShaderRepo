sampler2D img;
sampler2D bkd : register(s1);

float ColorBurn(float base, float blend)
{
    if (base >= 1.0)
        return 1.0;
    else if (blend <= 0.0)
        return 0.0;
    else    
    	return 1.0 - min(1.0, (1.0-base) / blend);
}

float4 ps_main(float4 color : COLOR0,in float2 In : TEXCOORD0) : COLOR0
{
	float4 L = tex2D(img,In);
	float4 B = tex2D(bkd,In);
	return float4(  ColorBurn(B.r, L.r), 
					ColorBurn(B.g, L.g), 
					ColorBurn(B.b, L.b),
								   L.a);
}


technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
