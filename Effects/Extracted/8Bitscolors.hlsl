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
// TWOBGS,BW,NES,EGA,CPC,CGA,GAMEBOY,TELETEXT,SMS
cbuffer PS_VARIABLES : register(b0)
{
float BRIGHTNESS;
float pixelSize;
int md;
bool TWOBGS;
bool BW;
bool NES;
bool EGA;
bool CPC;
bool CGA;
bool GAMEBOY;
bool TELETEXT;
bool SMS;
bool C64;
bool Z80;


};

float3 find_closest (in float3 ref) {	
	float3 old = float3 (100.0*255.0,100.0*255.0,100.0*255.0);		
	#define TRY_COLOR(new) old = lerp (new, old, step (length (old-ref), length (new-ref)));	
	
	if(TWOBGS){
    TRY_COLOR (float3 (000.0, 000.0, 000.0));
	TRY_COLOR (float3 (103.0, 103.0, 103.0));
    TRY_COLOR (float3 (184.0, 184.0, 184.0));    
    TRY_COLOR (float3 (255.0, 255.0, 255.0));    
    }
	
	if(BW){
    TRY_COLOR (float3 (000.0, 000.0, 000.0));
    TRY_COLOR (float3 (255.0, 255.0, 255.0));    
    }
	
	
    if(TELETEXT){
    TRY_COLOR (float3 (000.0, 000.0, 000.0));
    TRY_COLOR (float3 (255.0, 000.0, 000.0));
    TRY_COLOR (float3 (000.0, 255.0, 000.0));
    TRY_COLOR (float3 (000.0, 000.0, 255.0));
    TRY_COLOR (float3 (000.0, 255.0, 255.0));
    TRY_COLOR (float3 (255.0, 000.0, 255.0));
    TRY_COLOR (float3 (255.0, 255.0, 000.0));
    TRY_COLOR (float3 (255.0, 255.0, 255.0));    
    }
    
    
    if(NES){
	TRY_COLOR (float3 (000.0, 000.0, 000.0));
	TRY_COLOR (float3 (080.0, 048.0, 000.0));
	TRY_COLOR (float3 (000.0, 104.0, 000.0));
	TRY_COLOR (float3 (000.0, 064.0, 088.0));
	TRY_COLOR (float3 (000.0, 120.0, 000.0));
	TRY_COLOR (float3 (136.0, 020.0, 000.0));
	TRY_COLOR (float3 (000.0, 168.0, 000.0));
	TRY_COLOR (float3 (168.0, 016.0, 000.0));
	TRY_COLOR (float3 (168.0, 000.0, 032.0));
	TRY_COLOR (float3 (000.0, 168.0, 068.0));
	TRY_COLOR (float3 (000.0, 184.0, 000.0));
	TRY_COLOR (float3 (000.0, 000.0, 188.0));
	TRY_COLOR (float3 (000.0, 136.0, 136.0));
	TRY_COLOR (float3 (148.0, 000.0, 132.0));
	TRY_COLOR (float3 (068.0, 040.0, 188.0));
	TRY_COLOR (float3 (120.0, 120.0, 120.0));
	TRY_COLOR (float3 (172.0, 124.0, 000.0));
	TRY_COLOR (float3 (124.0, 124.0, 124.0));
	TRY_COLOR (float3 (228.0, 000.0, 088.0));
	TRY_COLOR (float3 (228.0, 092.0, 016.0));
	TRY_COLOR (float3 (088.0, 216.0, 084.0));
	TRY_COLOR (float3 (000.0, 000.0, 252.0));
	TRY_COLOR (float3 (248.0, 056.0, 000.0));
	TRY_COLOR (float3 (000.0, 088.0, 248.0));
	TRY_COLOR (float3 (000.0, 120.0, 248.0));
	TRY_COLOR (float3 (104.0, 068.0, 252.0));
	TRY_COLOR (float3 (248.0, 120.0, 088.0));
	TRY_COLOR (float3 (216.0, 000.0, 204.0));
	TRY_COLOR (float3 (088.0, 248.0, 152.0));
	TRY_COLOR (float3 (248.0, 088.0, 152.0));
	TRY_COLOR (float3 (104.0, 136.0, 252.0));
	TRY_COLOR (float3 (252.0, 160.0, 068.0));
	TRY_COLOR (float3 (248.0, 184.0, 000.0));
	TRY_COLOR (float3 (184.0, 248.0, 024.0));
	TRY_COLOR (float3 (152.0, 120.0, 248.0));
	TRY_COLOR (float3 (000.0, 232.0, 216.0));
	TRY_COLOR (float3 (060.0, 188.0, 252.0));
	TRY_COLOR (float3 (188.0, 188.0, 188.0));
	TRY_COLOR (float3 (216.0, 248.0, 120.0));
	TRY_COLOR (float3 (248.0, 216.0, 120.0));
	TRY_COLOR (float3 (248.0, 164.0, 192.0));
	TRY_COLOR (float3 (000.0, 252.0, 252.0));
	TRY_COLOR (float3 (184.0, 184.0, 248.0));
	TRY_COLOR (float3 (184.0, 248.0, 184.0));
	TRY_COLOR (float3 (240.0, 208.0, 176.0));
	TRY_COLOR (float3 (248.0, 120.0, 248.0));
	TRY_COLOR (float3 (252.0, 224.0, 168.0));
	TRY_COLOR (float3 (184.0, 248.0, 216.0));
	TRY_COLOR (float3 (216.0, 184.0, 248.0));
	TRY_COLOR (float3 (164.0, 228.0, 252.0));
	TRY_COLOR (float3 (248.0, 184.0, 248.0));
	TRY_COLOR (float3 (248.0, 216.0, 248.0));
	TRY_COLOR (float3 (248.0, 248.0, 248.0));
	TRY_COLOR (float3 (252.0, 252.0, 252.0));	
	}
	
	if(GAMEBOY){
	TRY_COLOR (float3 (156.0, 189.0, 015.0));
	TRY_COLOR (float3 (140.0, 173.0, 015.0));
	TRY_COLOR (float3 (048.0, 098.0, 048.0));
	TRY_COLOR (float3 (000.0, 000.0, 000.0)); // (015.0, 056.0, 015.0));
	}
    
    if(EGA){
    TRY_COLOR (float3 (000.0,000.0,000.0)); 
    TRY_COLOR (float3 (255.0,255.0,255.0)); 
    TRY_COLOR (float3 (255.0,  0.0,  0.0)); 
    TRY_COLOR (float3 (  0.0,255.0,  0.0)); 
    TRY_COLOR (float3 (  0.0,  0.0,255.0)); 
    TRY_COLOR (float3 (255.0,255.0,  0.0)); 
    TRY_COLOR (float3  (  0.0,255.0,255.0)); 
    TRY_COLOR (float3 (255.0,  0.0,255.0)); 
    TRY_COLOR (float3 (128.0,  0.0,  0.0)); 
    TRY_COLOR (float3 (  0.0,128.0,  0.0)); 
    TRY_COLOR (float3 (  0.0,  0.0,128.0)); 
    TRY_COLOR (float3 (128.0,128.0,  0.0)); 
    TRY_COLOR (float3 (  0.0,128.0,128.0)); 
    TRY_COLOR (float3 (128.0,  0.0,128.0)); 
    TRY_COLOR (float3 (128.0,128.0,128.0)); 
    TRY_COLOR (float3 (255.0,128.0,128.0)); 
    }
    
    if(CGA){
    TRY_COLOR (float3 (000.0,000.0,000.0)); 
    TRY_COLOR (float3 (000.0,170.0,170.0)); 
    TRY_COLOR (float3 (170.0,000.0,170.0)); 
    TRY_COLOR (float3 (170.0,170.0,170.0)); 
    }
    
    if(CPC){
    TRY_COLOR ( float3(000.0,000.0,000.0));
    TRY_COLOR ( float3(000.0,000.0,128.0));
    TRY_COLOR ( float3(000.0,000.0,255.0));
    TRY_COLOR ( float3(128.0,000.0,000.0));
    TRY_COLOR ( float3(128.0,000.0,128.0));
    TRY_COLOR ( float3(128.0,000.0,255.0));
    TRY_COLOR ( float3(255.0,000.0,000.0));
    TRY_COLOR ( float3(255.0,000.0,128.0));
    TRY_COLOR ( float3(255.0,000.0,255.0));
    TRY_COLOR ( float3(000.0,128.0,000.0)); 
    TRY_COLOR ( float3(000.0,128.0,128.0));
    TRY_COLOR ( float3(000.0,128.0,255.0)); 
    TRY_COLOR ( float3(128.0,128.0,000.0));
    TRY_COLOR ( float3(128.0,128.0,128.0));
    TRY_COLOR ( float3(128.0,128.0,255.0));
    TRY_COLOR ( float3(255.0,128.0,000.0));
    TRY_COLOR ( float3(255.0,128.0,128.0));
    TRY_COLOR ( float3(255.0,128.0,255.0));
    TRY_COLOR ( float3(000.0,255.0,000.0));
    TRY_COLOR ( float3(000.0,255.0,128.0));
    TRY_COLOR ( float3(000.0,255.0,255.0));
    TRY_COLOR ( float3(128.0,255.0,000.0));
    TRY_COLOR ( float3(128.0,255.0,128.0));
    TRY_COLOR ( float3(128.0,255.0,255.0));
    TRY_COLOR ( float3(255.0,255.0,000.0));
    TRY_COLOR ( float3(255.0,255.0,128.0));
    TRY_COLOR ( float3(255.0,255.0,255.0));
    }
    
    if(SMS){
     TRY_COLOR (float3(0,0,0));
     TRY_COLOR ( float3(85,0,0));
     TRY_COLOR ( float3(170,0,0));
     TRY_COLOR ( float3(255,0,0));
	 TRY_COLOR ( float3(0,85,0));
     TRY_COLOR ( float3(85,85,0));
     TRY_COLOR ( float3(170,85,0));
     TRY_COLOR ( float3(255,85,0));
	 TRY_COLOR ( float3(0,170,0));
     TRY_COLOR ( float3(85,170,0));
     TRY_COLOR ( float3(170,170,0));
     TRY_COLOR ( float3(255,170,0));
	 TRY_COLOR ( float3(0,255,0));
     TRY_COLOR ( float3(85,255,0));
     TRY_COLOR ( float3(170,255,0));
     TRY_COLOR ( float3(255,255,0));
	 TRY_COLOR ( float3(0,0,85));
     TRY_COLOR ( float3(85,0,85));
     TRY_COLOR ( float3(170,0,85));
     TRY_COLOR ( float3(255,0,85));
	 TRY_COLOR ( float3(0,85,85));
	 TRY_COLOR ( float3(85,85,85));
	 TRY_COLOR ( float3(170,85,85));
     TRY_COLOR ( float3(255,85,85));
     TRY_COLOR ( float3(0,170,85));
     TRY_COLOR ( float3(85,170,85));
	 TRY_COLOR ( float3(170,170,85));
     TRY_COLOR ( float3(255,170,85));
     TRY_COLOR ( float3(0,255,85));
     TRY_COLOR ( float3(85,255,85));
	 TRY_COLOR ( float3(170,255,85));
	 TRY_COLOR ( float3(255,255,85));
	 TRY_COLOR ( float3(0,0,170));
     TRY_COLOR ( float3(85,0,170));
     TRY_COLOR ( float3(170,0,170));
     TRY_COLOR ( float3(255,0,170));
	 TRY_COLOR ( float3(0,85,170));
     TRY_COLOR ( float3(85,85,170));
     TRY_COLOR ( float3(170,85,170));
     TRY_COLOR ( float3(255,85,170));
	 TRY_COLOR ( float3(0,170,170));
	 TRY_COLOR ( float3(85,170,170));
	 TRY_COLOR ( float3(170,170,170));
     TRY_COLOR ( float3(255,170,170));
     TRY_COLOR ( float3(0,255,170));
     TRY_COLOR ( float3(85,255,170));
	 TRY_COLOR ( float3(170,255,170));
     TRY_COLOR ( float3(255,255,170));
     TRY_COLOR ( float3(0,0,255));
     TRY_COLOR ( float3(85,0,255));
	 TRY_COLOR ( float3(170,0,255));
     TRY_COLOR ( float3(255,0,255));
	 TRY_COLOR ( float3(0,85,255));
     TRY_COLOR ( float3(85,85,255));
     TRY_COLOR ( float3(170,85,255));
	 TRY_COLOR ( float3(255,85,255));
	 TRY_COLOR ( float3(0,170,255));
     TRY_COLOR ( float3(85,170,255));
     TRY_COLOR ( float3(170,170,255));
	 TRY_COLOR ( float3(255,170,255));
	 TRY_COLOR ( float3(0,255,255));
     TRY_COLOR ( float3(85,255,255));
     TRY_COLOR ( float3(170,255,255));
	 TRY_COLOR ( float3(255,255,255));
    }
	if(C64){
	TRY_COLOR(float3(0,0,0)*255.0);// black
	TRY_COLOR(float3(1,1,1)*255.0);// white
	TRY_COLOR(float3(0.41,0.22,0.17)*255.0);
	TRY_COLOR(float3(0.44,0.64,0.70)*255.0);
	TRY_COLOR(float3(0.44,0.24,0.53)*255.0);
	TRY_COLOR(float3(0.35,0.55,0.26)*255.0);
	TRY_COLOR(float3(0.21,0.16,0.47)*255.0);
	TRY_COLOR(float3(0.72,0.78,0.44)*255.0);
	TRY_COLOR(float3(0.44,0.31,0.15)*255.0);
	TRY_COLOR(float3(0.26,0.22,0.00)*255.0); 
	TRY_COLOR(float3(0.60,0.40,0.35)*255.0);
	TRY_COLOR(float3(0.27,0.27,0.27)*255.0);
	TRY_COLOR(float3(0.42,0.42,0.42)*255.0);
	TRY_COLOR(float3(0.60,0.82,0.52)*255.0);
	TRY_COLOR(float3(0.42,0.37,0.71)*255.0);
	TRY_COLOR(float3(0.58,0.58,0.58)*255.0);
	}
	if(Z80){
	TRY_COLOR(float3(0,0,0));// black
	TRY_COLOR(float3(0,0,255.0));// bluez80
	TRY_COLOR(float3(0,0,192.0));// bluez80
	TRY_COLOR(float3(255.0,0,0));
	TRY_COLOR(float3(192.0,0,0));
	TRY_COLOR(float3(255.0,0,255.0));
	TRY_COLOR(float3(192.0,0,192.0));	
	TRY_COLOR(float3(0,255.0,0));
	TRY_COLOR(float3(0,192.0,0));
	TRY_COLOR(float3(0,255.0,255.0));
	TRY_COLOR(float3(0,192.0,192.0));
	TRY_COLOR(float3(255.0,255.0,0));
	TRY_COLOR(float3(192.0,192.0,0));
	TRY_COLOR(float3(255.0,255.0,255.0));
	TRY_COLOR(float3(192.0,192.0,192.0));
	
	
 	}
	    
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
        // float pixelSize = 300.0;
		 
	      In.Uv = floor(In.Uv * (pixelSize*10.0))/(pixelSize*10.0);
		 
               if(md==1){

		     Out.Color  = float4(dither(Texture0.Sample(Tex0, In.Uv).rgb,In.Uv),1.0);
	   
              }
               else
			{
               Out.Color = Texture0.Sample(Tex0, In.Uv)* In.Tint;
			}
	return Out;
}

 