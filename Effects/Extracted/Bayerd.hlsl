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
 
cbuffer PS_VARIABLES : register(b0)
{

float lvl;
 
};

//static const float kernel[9]={aa,bb,cc,dd,ee,ff,gg,hh,ii}; 

static const float4x4 bayertl = float4x4(
0.0/64.0, 32.0/64.0, 8.0/64.0, 40.0/64.0, 48.0/64.0, 16.0/64.0, 56.0/64.0, 24.0/64.0, 12.0/64.0, 44.0/64.0, 4.0/64.0, 36.0/64.0, 60.0/64.0, 28.0/64.0, 52.0/64.0, 20.0/64.0
);
static const float4x4 bayertr = float4x4(
2.0/64.0, 34.0/64.0, 10.0/64.0, 42.0/64.0, 50.0/64.0, 18.0/64.0, 58.0/64.0, 26.0/64.0, 14.0/64.0, 46.0/64.0, 6.0/64.0, 38.0/64.0, 62.0/64.0, 30.0/64.0, 54.0/64.0, 22.0/64.0
);
static const float4x4 bayerbl = float4x4(
3.0/64.0, 35.0/64.0, 11.0/64.0, 43.0/64.0, 51.0/64.0, 19.0/64.0, 59.0/64.0, 27.0/64.0, 15.0/64.0, 47.0/64.0, 7.0/64.0, 39.0/64.0, 63.0/64.0, 31.0/64.0, 55.0/64.0, 23.0/64.0
);
static const float4x4 bayerbr = float4x4(
1.0/64.0, 33.0/64.0, 9.0/64.0, 41.0/64.0, 49.0/64.0, 17.0/64.0, 57.0/64.0, 25.0/64.0, 13.0/64.0, 45.0/64.0, 5.0/64.0, 37.0/64.0, 61.0/64.0, 29.0/64.0, 53.0/64.0, 21.0/64.0
);

float dither( float4x4 m, int2 p ) {
    if( p.y == 0 ) {
        if( p.x == 0 ) return m[0][0];
        else if( p.x == 1 ) return m[1][0];
        else if( p.x == 2 ) return m[2][0];
        else return m[3][0];
    }
    else if( p.y == 1 ) {
        if( p.x == 0 ) return m[0][1];
        else if( p.x == 1 ) return m[1][1];
        else if( p.x == 2 ) return m[2][1];
        else return m[3][1];
    }
    else if( p.y == 2 ) {
        if( p.x == 0 ) return m[0][1];
        else if( p.x == 1 ) return m[1][2];
        else if( p.x == 2 ) return m[2][2];
        else return m[3][2];
    }
    else {
        if( p.x == 0 ) return m[0][3];
        else if( p.x == 1 ) return m[1][3];
        else if( p.x == 2 ) return m[2][3];
        else return m[3][3];
    }

}

 

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
             
    PS_OUTPUT Out;
    
    // for(int x = -1; x <= 1; x++){
        // for(int y = -1; y <= 1; y++){
            // Out.Color += kernel[(x+1) + 3*(y+1)] * float4(Texture0.Sample(Tex0, In.Uv + float2(x,y)/In.Position.xy));
        // }
    // }   
    
	int2 p = int2(fmod( In.Position.xy, lvl ));//8.0
   
    float3 c = Texture0.Sample(Tex0, In.Uv).xyz;
  //  c = pow( c, float3(2.2,2.2,2.2) );
  //  c -= 1.0/255.0;
    float3 d = float3(0.0,0.0,0.0);
    if( p.x <= 3 && p.y <= 3 ) {
        d.r = float( c.r > dither( bayertl, p ) );
        d.g = float( c.g > dither( bayertl, p ) );
        d.b = float( c.b > dither( bayertl, p ) );
    }
    else if ( p.x > 3 && p.y <= 3 ) {
        d.r = float( c.r > dither( bayertr, p -int2(4, 0) ) );
        d.g = float( c.g > dither( bayertr, p -int2(4, 0) ) );
        d.b = float( c.b > dither( bayertr, p -int2(4, 0) ) );
    }
    else if( p.x <= 3 && p.y > 3 ) {
        d.r = float( c.r > dither( bayerbl, p-int2(0, 4)  ) );
        d.g = float( c.g > dither( bayerbl, p-int2(0, 4)  ) );
        d.b = float( c.b > dither( bayerbl, p-int2(0, 4)  ) );
    }
    else if ( p.x > 3 && p.y > 3 ) {
        d.r = float( c.r > dither( bayerbr, p -int2(4, 4) ) );
        d.g = float( c.g > dither( bayerbr, p -int2(4, 4) ) );
        d.b = float( c.b > dither( bayerbr, p -int2(4, 4) ) );
    }
    Out.Color = float4(d, 1.0);
	
	return Out;
}

 