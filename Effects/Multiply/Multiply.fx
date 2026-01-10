// This shader was made for Five Nights at Candy's Remastered
// by Emil "Ace" Macko

sampler2D img : register(s0);
sampler2D bg : register(s1);

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0
{
	return tex2D(bg, texCoord) * tex2D(img, texCoord);
}

technique tech_main
{
	pass P0
	{
		VertexShader = NULL;
		PixelShader = compile ps_2_a ps_main();
	}	
}