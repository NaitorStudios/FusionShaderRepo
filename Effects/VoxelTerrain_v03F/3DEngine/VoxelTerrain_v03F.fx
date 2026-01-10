sampler2D imgHeightmap : register( s1 );
sampler2D imgTexturemap : register( s2 );
float fX, fY, fZ, fCosPan, fSinPan, fCosTilt, fSinTilt, fYScale, fPixelWidth, fPixelHeight;

struct PS_OUTPUT {
	float4 Color : COLOR0;
  	float Depth : DEPTH;
};

PS_OUTPUT ps_main( float2 In : TEXCOORD0 ) {
	PS_OUTPUT outPixel;	
	float4 outColor = float4( 0, 0, 0, 0 );
	float3 p = float3(( In.x - 0.5 ), (0.5 - In.y ) * fPixelWidth / fPixelHeight, 0.5);
	p = float3(p.x, ( p.y * fCosTilt ) + ( p.z * fSinTilt ),( p.y * fSinTilt ) - ( p.z * fCosTilt ));
	p = normalize(float3(( p.x * fCosPan ) - ( p.z * fSinPan ), p.y, ( p.x * fSinPan ) + ( p.z * fCosPan )));
	float3 ray = float3( fX, fY, fZ );
	float3 step = p * 0.003; // --> ray length factor (higher=more depth, but more "flicker" on diagonal rays)
	for ( int i = 0; i < 68; i++) {
		if ( step.x < 10000 ) {
			ray+= step;
		}
		if ( tex2D( imgHeightmap, ray.xz ).r * fYScale > ray.y ) {
			step.x=10000;
		}
	}
	if ( step.x >= 10000 ) {
		outColor = tex2D( imgTexturemap, ray.xz );
	} 
	outPixel.Depth = length( ray - float3( fX, fY, fZ )) / 0.003 / 136.0;
	outPixel.Color = outColor;
	return outPixel;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}