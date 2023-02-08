// Global variables
sampler2D Tex0 : register(s0);
//sampler2D palette;

float BRIGHTNESS;


float3 find_closest(float3 ref) {	
	float3 old = 100.0 * 255.0;		
	#define TRY_COLOR(new) old = lerp(new, old, step( length(old-ref), length(new-ref)) );	
	TRY_COLOR (float3 (156.0, 189.0, 015.0));
	TRY_COLOR (float3 (140.0, 173.0, 015.0));
	TRY_COLOR (float3 (048.0, 098.0, 048.0));
	TRY_COLOR (float3 (000.0, 000.0, 000.0)); // (015.0, 056.0, 015.0));
	    
	return old;
}	


float dither_matrix(float x, float y) {
	return lerp(lerp(lerp(lerp(lerp(lerp(0.0,32.0,step(1.0,y)),lerp(8.0,40.0,step(3.0,y)),step(2.0,y)),lerp(lerp(2.0,34.0,step(5.0,y)),lerp(10.0,42.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(48.0,16.0,step(1.0,y)),lerp(56.0,24.0,step(3.0,y)),step(2.0,y)),lerp(lerp(50.0,18.0,step(5.0,y)),lerp(58.0,26.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(1.0,x)),lerp(lerp(lerp(lerp(12.0,44.0,step(1.0,y)),lerp(4.0,36.0,step(3.0,y)),step(2.0,y)),lerp(lerp(14.0,46.0,step(5.0,y)),lerp(6.0,38.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(60.0,28.0,step(1.0,y)),lerp(52.0,20.0,step(3.0,y)),step(2.0,y)),lerp(lerp(62.0,30.0,step(5.0,y)),lerp(54.0,22.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(3.0,x)),step(2.0,x)),lerp(lerp(lerp(lerp(lerp(3.0,35.0,step(1.0,y)),lerp(11.0,43.0,step(3.0,y)),step(2.0,y)),lerp(lerp(1.0,33.0,step(5.0,y)),lerp(9.0,41.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(51.0,19.0,step(1.0,y)),lerp(59.0,27.0,step(3.0,y)),step(2.0,y)),lerp(lerp(49.0,17.0,step(5.0,y)),lerp(57.0,25.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(5.0,x)),lerp(lerp(lerp(lerp(15.0,47.0,step(1.0,y)),lerp(7.0,39.0,step(3.0,y)),step(2.0,y)),lerp(lerp(13.0,45.0,step(5.0,y)),lerp(5.0,37.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(63.0,31.0,step(1.0,y)),lerp(55.0,23.0,step(3.0,y)),step(2.0,y)),lerp(lerp(61.0,29.0,step(5.0,y)),lerp(53.0,21.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(7.0,x)),step(6.0,x)),step(4.0,x));
}

float3 dither(float3 color, float2 In) {	
	color *= 255.0 * BRIGHTNESS;	
	//color = dither_matrix (fmod (In.x, 8.0), fmod (In.y, 8.0)) ;
	color = find_closest( clamp( color, 0.0, 255.0 ) );
	return color / 255.0;
}


float4 ps_main(in float2 In : TEXCOORD) : COLOR
{
    float4 Out;  
	float3 fc = dither( tex2D( Tex0, In ).rgb, In );
	Out.rgba  = float4( fc, 1.0 );
	return Out;
}


technique tech_main
{
	pass p0
	{
		VertexShader = null;
		PixelShader = compile ps_2_b ps_main();
	}
}
 