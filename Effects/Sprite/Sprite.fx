sampler2D img;
int iYLevel, iNumYLevels;
float fDepth;
float4 cFog;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
	float4 outColor = tex2D( img, float2( In.x, In.y / iNumYLevels + ( iYLevel * 1.0 / iNumYLevels )));
	outColor.rgb = lerp( outColor.rgb, cFog.rgb, ( max( 0.5, fDepth ) - 0.5 ) * 2.0 );
	return outColor;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}