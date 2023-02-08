sampler2D imgHeightmap : register( s1 );
sampler2D imgTexturemap : register( s2 );
float fX, fY, fZ, fCosAngle, fSinAngle, fYScale;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {

	// Set default output color (transparent)	
	float4 outColor = float4( 0, 0, 0, 0 );

	// Create 3D vector from camera to screen pixel (maps coordinates to range X:+/-0.5 and Y:+/-0.25)
	float3 p0 =  float3( In.x - 0.5, 0.25 - ( In.y * 0.5 ), 0.5 );

	// Rotate vector around Y-axis (cos and sin are pre-calculated and passed as parameters)
	float3 p1 = p0;
	p1.x = ( p0.x * fCosAngle ) + ( p0.z * fSinAngle );
	p1.z = ( p0.z * fCosAngle ) - ( p0.x * fSinAngle );
	
float3 p = p1;
	p.y = ( p1.y * 0.92387953251 ) - ( p1.z * 0.38268343236 );
	p.z = ( p1.y * 0.38268343236 ) + ( p1.z * 0.92387953251 );

	//float angleY = (In.y - 0.33) * 90 * 0.0174533 * 1.5;
	
	// Normalize the vector (give it a length of 1) - not strictly needed.
	normalize( p );

	// Raycasting procedure:
	// Define a value which determines if our ray has been blocked by land.
	int blocked = 0;

	for (int i=0; i<49; i++) {
		float dist = (i / 49.0) * 0.3; 		
		float2 xyPos = float2( fX + (p.x * dist), fZ + (p.z * dist));
		float testHeight = tex2D( imgHeightmap, xyPos );
		if (blocked == 0 && testHeight.r*0.075 >  0.045 +  (p.y * dist)) {
			outColor = tex2D( imgTexturemap, xyPos );
			blocked = 100;
		}
	}
	return outColor;
}

technique tech_main {
	pass P0 {
		PixelShader = compile ps_2_a ps_main();
	}
}