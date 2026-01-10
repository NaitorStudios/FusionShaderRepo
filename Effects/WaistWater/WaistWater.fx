// Global variables	
sampler2D tex : register(s0);

float alpha, water_start, water_end;

float4 ps_main(float2 texCoord : TEXCOORD) : COLOR
{
    float4 c = tex2D(tex, texCoord);
    float v = acos((texCoord.x - 0.5) * 2.0);
    float a = texCoord.y >= water_start + (water_end - water_start) * sin(v) ? alpha : 1.0;
    return float4(c.rgb, c.a * a);
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}