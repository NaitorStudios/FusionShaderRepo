// Shader by Emil Macko
sampler2D img : register(s0);
sampler2D bg : register(s1);

int intens, L1x, L1y, L1z, L2x, L2y, L2z, L3x, L3y, L3z, L4x, L4y, L4z;
float4 amb, L1c, L2c, L3c, L4c;
float fPixelWidth, fPixelHeight;
	
float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0 
{
	float4 norm = tex2D(img, texCoord);
	norm.rgb = norm.rgb * 2.0 - 1.0;
	float3 pos = float3(texCoord.x / fPixelWidth, texCoord.y / fPixelHeight, 0.0);
	float3 col = 0.0;
	float3 lights[8] = {
		float3(L1x, L1y, L1z), L1c.rgb,
		float3(L2x, L2y, L2z), L2c.rgb,
		float3(L3x, L3y, L3z), L3c.rgb,
		float3(L4x, L4y, L4z), L4c.rgb};
	
	for(int i = 0; i < 8; i += 2)
	{
		float3 dir = lights[i] - pos;
		col += lights[i+1] * round(max(dot(norm.rgb, normalize(dir)), 0.0) / (length(dir) / intens));
	}
	
	col = tex2D(bg, texCoord).rgb * (amb.rgb + col);
	
	return float4(col, norm.a);
}

technique tech_main
{
    pass P0
    {
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }  
}