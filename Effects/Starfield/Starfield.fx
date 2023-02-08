// Global variables
Texture2D<float4> Texture0 : register(t0);
sampler Tex0 : register(s0);

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 Uv : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

float BRIGHTNESS;
int md;


float3 find_closest (in float3 ref) {	
	float3 old = float3 (100.0*255.0,100.0*255.0,100.0*255.0);		
	#define TRY_COLOR(new) old = lerp (new, old, step (length (old-ref), length (new-ref)));	
	TRY_COLOR (float3(0,0,0));// black
	TRY_COLOR (float3(1,1,1));// white
	TRY_COLOR (float3(0.41,0.22,0.17));// red
	TRY_COLOR (float3(0.44,0.64,0.70));// cyan
	 
	 
	 
	 
	 
	    
	return old;
}	


float dither_matrix (float x, float y) {
	return lerp(lerp(lerp(lerp(lerp(lerp(0.0,32.0,step(1.0,y)),lerp(8.0,40.0,step(3.0,y)),step(2.0,y)),lerp(lerp(2.0,34.0,step(5.0,y)),lerp(10.0,42.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(48.0,16.0,step(1.0,y)),lerp(56.0,24.0,step(3.0,y)),step(2.0,y)),lerp(lerp(50.0,18.0,step(5.0,y)),lerp(58.0,26.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(1.0,x)),lerp(lerp(lerp(lerp(12.0,44.0,step(1.0,y)),lerp(4.0,36.0,step(3.0,y)),step(2.0,y)),lerp(lerp(14.0,46.0,step(5.0,y)),lerp(6.0,38.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(60.0,28.0,step(1.0,y)),lerp(52.0,20.0,step(3.0,y)),step(2.0,y)),lerp(lerp(62.0,30.0,step(5.0,y)),lerp(54.0,22.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(3.0,x)),step(2.0,x)),lerp(lerp(lerp(lerp(lerp(3.0,35.0,step(1.0,y)),lerp(11.0,43.0,step(3.0,y)),step(2.0,y)),lerp(lerp(1.0,33.0,step(5.0,y)),lerp(9.0,41.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(51.0,19.0,step(1.0,y)),lerp(59.0,27.0,step(3.0,y)),step(2.0,y)),lerp(lerp(49.0,17.0,step(5.0,y)),lerp(57.0,25.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(5.0,x)),lerp(lerp(lerp(lerp(15.0,47.0,step(1.0,y)),lerp(7.0,39.0,step(3.0,y)),step(2.0,y)),lerp(lerp(13.0,45.0,step(5.0,y)),lerp(5.0,37.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),lerp(lerp(lerp(63.0,31.0,step(1.0,y)),lerp(55.0,23.0,step(3.0,y)),step(2.0,y)),lerp(lerp(61.0,29.0,step(5.0,y)),lerp(53.0,21.0,step(7.0,y)),step(6.0,y)),step(4.0,y)),step(7.0,x)),step(6.0,x)),step(4.0,x));
}

float3 dither (float3 color, float2 uv) {	
	color *= 255.0 * BRIGHTNESS;	
	//color = dither_matrix (fmod (uv.x, 8.0), fmod (uv.y, 8.0)) ;
	color = find_closest (clamp (color, 0.0, 255.0));
	return color / 255.0;
}


PS_OUTPUT ps_main( in PS_INPUT In )
{
             
    PS_OUTPUT Out;
        
		float3 fc = dither (Texture0.Sample(Tex0, In.Uv.xy).rgb,In.Uv.xy);
               if(md==1){

		     Out.Color  = float4(fc,1.0);
	   
              }
               else
			{
               Out.Color = Texture0.Sample(Tex0, In.Uv.xy);
			}
	return Out;
}

 