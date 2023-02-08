sampler2D img : register(s0);
float oRED;
float oGREEN;
float oBLUE;

float nRED;
float nGREEN;
float nBLUE;

float bRED;
float bGREEN;
float bBLUE;
float4 pixelColor;



float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{


		float4 pixelColour = tex2D( img, texCoord );

		float4 replaceColour = float4(0.0,1.0,0.0,1.0);
		float4 replaceColourA = float4(1.0,0.0,0.0,1.0);
		float4 replaceColourB = float4(0.0,0.0,1.0,1.0);

		if ( pixelColour.r == replaceColour.r && pixelColour.g == replaceColour.g && pixelColour.b == replaceColour.b ) {
				pixelColour = float4(nRED,nGREEN,nBLUE,1.0);
				}


		if ( pixelColour.r == replaceColourA.r && pixelColour.g == replaceColourA.g && pixelColour.b == replaceColourA.b ) {
				pixelColour = float4(oRED,oGREEN,oBLUE,1.0);
				}
		if ( pixelColour.r == replaceColourB.r && pixelColour.g == replaceColourB.g && pixelColour.b == replaceColourB.b ) {
				pixelColour = float4(bRED,bGREEN,bBLUE,1.0);
				}

		return pixelColour;

}





technique tech_main	{ pass P0 { PixelShader = compile ps_2_0 ps_main(); }  }
