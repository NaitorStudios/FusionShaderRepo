sampler2D imgHeightmap : register( s1 );
sampler2D imgTexturemap : register( s2 );
sampler2D imgSky : register( s3 );
float fX, fY, fZ, fPan, fCosPan, fSinPan, fCosTilt, fSinTilt, fYScale, fPixelWidth, fPixelHeight;
float4 cFog;

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
	float3 step = p * 0.003; // --> ray length factor (higher=more depth, but more "flicker" on diagonal rays)
	float3 ray = float3( fX, fY, fZ ) + ( step * 68.0 );
	for ( int i = 0; i < 67; i++) {
		if ( step.x < 10000 ) {
			ray += step;
		}
		if ( tex2D( imgHeightmap, ray.xz ).r * fYScale > ray.y ) {
			step.x=10000;
		}
	}
	if ( step.x >= 10000 ) {
		outColor = tex2D( imgTexturemap, ray.xz );
	} 
	outPixel.Depth = length( ray - float3( fX, fY, fZ )) / 0.003 / 136.0;
	if ( outColor.a > 0 ) {
		outPixel.Color.rgb = lerp( outColor.rgb, cFog.rgb, ( outPixel.Depth - 0.5) * 2.0 );
	} else {
		outPixel.Color = tex2D( imgSky, float2(( In.x + ( fPan / 90.0 )) * 0.25, In.y * 2.0 ));	
	}
	outPixel.Color.a = 1.0;
	return outPixel;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}