sampler2D img;
sampler2D bkd : register(s1);
float4 colorA, colorB, colorC, colorD, colorE;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{ 
	float4 colorOut = colorA;
	float4 colors[5];
	colors[0] = colorA;
	colors[1] = colorB;
	colors[2] = colorC;
	colors[3] = colorD;
	colors[4] = colorE;
	float delta = tex2D( img, In ) * 9.0 - 5 ;
	float4 colorIn = tex2D( bkd, In );
	for ( float i = 0; i < 5; i++ ) {
		if ( all( colorIn == colors[i] )) {
			colorOut = colors[ min( max( i + delta, 0 ), 4 ) ];
		}
	}
 	return colorOut; 
} 

technique tech_main {
	pass P0 { PixelShader = compile ps_2_a ps_main(); }
}