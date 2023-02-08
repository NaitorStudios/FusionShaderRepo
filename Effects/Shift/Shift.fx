sampler2D img;
sampler2D bkd : register(s1);
float4 colorA, colorB, colorC, colorD;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0	{ 
	float4 colorOut = colorA;
	float4x4 colors = float4x4( colorA, colorB, colorC, colorD );
	float delta = ( tex2D( img, In ) * 6 ) - 3;
	float4 colorIn = tex2D( bkd, In );
	for ( float i = 0; i < 4; i++ ) {
		if ( all( colorIn == colors[i] )) {
			colorOut = colors[ min( max( i + delta, 0 ), 3 ) ];
		}
	}
 	return colorOut; 
} 

technique tech_main {
	pass P0 { PixelShader = compile ps_2_a ps_main(); }
}