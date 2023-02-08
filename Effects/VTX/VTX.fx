sampler2D imgHeightmap : register( s1 );
sampler2D imgTexturemap : register( s2 );
float fX, fY, fZ, fCosAngle, fSinAngle, fYScale;

float4 ps_main( in float2 In : TEXCOORD0 ) : COLOR0 {

	// Set default output color (transparent)	
	float4 outColor = float4( 0, 0, 0, 0 );

	// Create 3D vector from camera to screen pixel (maps coordinates to range X:+/-0.5 and Y:+/-0.25)
	float3 p0 =  float3( In.x - 0.5, 0.25 - ( In.y * 0.5 ), 0.5 );

	// Rotate vector around Y-axis (cos and sin are pre-calculated and passed as parameters)
	float3 p = p0;
	p.x = ( p0.x * fCosAngle ) + ( p0.z * fSinAngle );
	p.z = ( p0.z * fCosAngle ) - ( p0.x * fSinAngle );

	// Normalize the vector (give it a length of 1) - not strictly needed.
	normalize( p );

	// Raycasting procedure:
	// Define a value which determines if our ray has been blocked by land.
	int blocked = 0;

	// Start a loop 100 times, which will cast a ray from the camera in the direction of the current screen pixel.
	for( int i=0; i<47; i++ ) {
		// Increase the length of the current ray with each loop iteration.
		float d = i / 47.0 * 0.5;

		// Multiply the ray vector by the length value;
		p *= d;

		// Get the height from the heightmap at the current ray coordinates.
		float4 height = tex2D( imgHeightmap, float2( fX + p.x, fZ + p.z ));

		// If the current ray coordinate is below the height of the land, get the color from the texturemap...
		if ( height.r * fYScale > blocked + fY + p.y ) { 
			outColor = tex2D( imgTexturemap, float2( fX + p.x, fZ + p.z ));
			// ...and set the blocked value to ensure it can't happen again.
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