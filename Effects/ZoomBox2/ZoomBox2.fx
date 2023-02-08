sampler2D img : register(s0);
int sourceX, sourceY, sourceWidth, sourceHeight, windowX, windowY, windowWidth, windowHeight;
float fPixelWidth, fPixelHeight;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {
	
	float4 outColor = float4( 0, 0, 0, 0 );

	float wndMinX = windowX * fPixelWidth;
	float wndMaxX = ( windowX + windowWidth ) * fPixelWidth;
	float wndMinY = windowY * fPixelHeight;
	float wndMaxY = ( windowY + windowHeight ) * fPixelHeight;

	if ( In.x >= wndMinX && In.x <= wndMaxX && In.y >= wndMinY && In.y <= wndMaxY ) {
		float srcMinX = sourceX * fPixelWidth;
		float srcMaxX = ( sourceX + sourceWidth ) * fPixelWidth;
		float srcMinY = sourceY * fPixelHeight;
		float srcMaxY = ( sourceY + sourceHeight ) * fPixelHeight;		
		float posX = ( In.x - wndMinX ) / ( wndMaxX - wndMinX );
		float posY = ( In.y - wndMinY ) / ( wndMaxY - wndMinY );
		float2 posXY = float2( lerp( srcMinX, srcMaxX, posX ), lerp( srcMinY, srcMaxY, posY ));
		outColor = tex2D( img, posXY );
	}

	return outColor;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}