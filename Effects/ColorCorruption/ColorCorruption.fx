sampler2D Tex0;
float4 color;
float intensity;
float seed;

float fPixelWidth;
float fPixelHeight;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0
{
    float4 col = tex2D(Tex0, In);

    
    float r = col.r;
    float g = col.g;
    float b = col.b;
    float a = col.a;

    
    float groupR = floor(r * (1.0/fPixelWidth));
    float groupG = floor(g * (1.0/fPixelHeight));
    float groupB = floor(b * (1.0/fPixelWidth));
    float2 groupUV = float2(groupR, groupG) / float2(fPixelWidth, fPixelHeight);

    
    float rand = frac(sin(dot(float2(groupUV.x, groupUV.y + seed), float2(12.9898, 78.233))) * 43758.5453);

    
    if (rand < intensity)
    {
        // Generate a new random color for the pixel
        float3 randColor = float3(
            frac(sin(rand * 1.234 + groupUV.x + seed) * 567.123),
            frac(sin(rand * 5.678 + groupUV.y + seed) * 789.456),
            frac(sin(rand * 9.012 + seed) * 345.678)
        );
        col.rgb = lerp(col.rgb, randColor * color.rgb, intensity);
        col.a = a;  
    }
    else
    {
        col.rgb *= color.rgb;
        col.a = a;
    }

    clip(col.a - 0.5);
	return col;
}

// Effect technique
technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader	= NULL;
		PixelShader		= compile ps_2_a ps_main();
	}	
}