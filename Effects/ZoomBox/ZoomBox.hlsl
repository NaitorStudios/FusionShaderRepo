
struct PS_INPUT {
	float4 tint : COLOR0;
	float2 texCoord : TEXCOORD0;
	float4 position : SV_POSITION;
};

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0) {
	int sourceX, sourceY, sourceWidth, sourceHeight, windowX, windowY, windowWidth, windowHeight;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 ps_main(in PS_INPUT In) : SV_TARGET {
	
	float4 outColor = 0;

	float wndMinX = windowX * fPixelWidth;
	float wndMaxX = ( windowX + windowWidth ) * fPixelWidth;
	float wndMinY = windowY * fPixelHeight;
	float wndMaxY = ( windowY + windowHeight ) * fPixelHeight;

	if ( In.texCoord.x >= wndMinX && In.texCoord.x <= wndMaxX && In.texCoord.y >= wndMinY && In.texCoord.y <= wndMaxY ) {
		float srcMinX = sourceX * fPixelWidth;
		float srcMaxX = ( sourceX + sourceWidth ) * fPixelWidth;
		float srcMinY = sourceY * fPixelHeight;
		float srcMaxY = ( sourceY + sourceHeight ) * fPixelHeight;		
		float posX = ( In.texCoord.x - wndMinX ) / ( wndMaxX - wndMinX );
		float posY = ( In.texCoord.y - wndMinY ) / ( wndMaxY - wndMinY );
		float2 posXY = float2( lerp( srcMinX, srcMaxX, posX ), lerp( srcMinY, srcMaxY, posY ));
		outColor = bkd.Sample( bkdSampler, posXY );
	}
	
	outColor *= In.tint;
	return outColor;
}