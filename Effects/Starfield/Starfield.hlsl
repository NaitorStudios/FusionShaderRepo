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
float val;
int dir;


};

float2 mod289(float2 x) {
		  return x - floor(x * (1.0 / 289.0)) * 289.0;
		}

		float3 mod289(float3 x) {
		  	return x - floor(x * (1.0 / 289.0)) * 289.0;
		}
		
		float4 mod289(float4 x) {
		  	return x - floor(x * (1.0 / 289.0)) * 289.0;
		}
		
		float3 permute(float3 x) {
		  return mod289(((x*34.0)+1.0)*x);
		}

		float4 permute(float4 x) {
		  return fmod((34.0 * x + 1.0) * x, 289.0);
		}

		float4 taylorInvSqrt(float4 r)
		{
		  	return 1.79284291400159 - 0.85373472095314 * r;
		}
		
		float snoise(float2 v)
		{
				const float4 C = float4(0.211324865405187,0.366025403784439,-0.577350269189626,0.024390243902439);
				float2 i  = floor(v + dot(v, C.yy) );
				float2 x0 = v -   i + dot(i, C.xx);
				
				float2 i1;
				i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				
				i = mod289(i); // Avoid truncation effects in permutation
				float3 p = permute( permute( i.y + float3(0.0, i1.y, 1.0 ))
					+ i.x + float3(0.0, i1.x, 1.0 ));
				
				float3 m = max(0.5 - float3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
				m = m*m ;
				m = m*m ;
				
				float3 x = 2.0 * frac(p * C.www) - 1.0;
				float3 h = abs(x) - 0.5;
				float3 ox = floor(x + 0.5);
				float3 a0 = x - ox;
				
				m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
				
				float3 g;
				g.x  = a0.x  * x0.x  + h.x  * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;

				return 130.0 * dot(m, g);		
		}
		
		float cellular2x2(float2 P)
		{
				#define K 0.142857142857 // 1/7
				#define K2 0.0714285714285 // K/2
				#define jitter 0.8 // jitter 1.0 makes F1 wrong more often
				
				float2 Pi = fmod(floor(P), 289.0);
				float2 Pf = frac(P);
				float4 Pfx = Pf.x + float4(-0.5, -1.5, -0.5, -1.5);
				float4 Pfy = Pf.y + float4(-0.5, -0.5, -1.5, -1.5);
				float4 p = permute(Pi.x + float4(0.0, 1.0, 0.0, 1.0));
				p = permute(p + Pi.y + float4(0.0, 0.0, 1.0, 1.0));
				float4 ox = fmod(p, 7.0)*K+K2;
				float4 oy = fmod(floor(p*K),7.0)*K+K2;
				float4 dx = Pfx + jitter*ox;
				float4 dy = Pfy + jitter*oy;
				float4 d = dx * dx + dy * dy; // d11, d12, d21 and d22, squared
				// Sort out the two smallest distances
				
				// Cheat and pick only F1
				d.xy = min(d.xy, d.zw);
				d.x = min(d.x, d.y);
				return d.x; // F1 duplicated, F2 not computed
		}
        

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
             
    PS_OUTPUT Out;
    
		float2 GA=float2(0.0,0.0);
		if (dir==0)   {GA.y +=val;}
        if (dir==1)   {GA.y -=val;}
        if (dir==2)   {GA.x +=val;}
        if (dir==3)   {GA.x -=val;} 			
      
	
     float   F1 = 0.0;
	 float   F2 = 0.0;
	 float   F3 = 0.0;
	 float   F4 = 0.0;
	 float   F5 = 0.0;
	 float   F6 = 0.0;
	 float   F7 = 0.0;
	 float   F8 = 0.0; 
	 
	 float   N1 = 0.0;
	 float   N2 = 0.0;
	 float   N3 = 0.0;
	 float   N4 = 0.0;
	 float   N5 = 0.0;
	 float   N6 = 0.0;
	 float   N7 = 0.0;
	 float   N8 = 0.0; 
	 
	 float  A = 0.0;
	 float   A1 = 0.0;
	 float   A2 = 0.0;
	 float   A3 = 0.0;
	 float   A4 = 0.0;
	 float   A5 = 0.0;
	 float   A6 = 0.0;
	 float   A7 = 0.0;
     float   A8 = 0.0; 	 
	 
	 
	 

	// Snow layers, somewhat like an fbm with worley layers.
	F1 = 1.0-cellular2x2((In.Uv.xy+(GA.xy*0.1))*8.0);	
	A1 = 1.0-(A*0.8);
	N1 = smoothstep(0.9998,1.0,F1)*0.2*A1;	

	F2 = 1.0-cellular2x2((In.Uv+(GA*0.2))*7.0);	
	A2 = 1.0-(A*0.8);
	N2 = smoothstep(0.9998,1.0,F2)*0.3*A2;				

	F3 = 1.0-cellular2x2((In.Uv+(GA*0.3))*6.0);	
	A3 = 1.0-(A*0.8);
	N3 = smoothstep(0.9998,1.0,F3)*0.4*A3;			
            
    F4 = 1.0-cellular2x2((In.Uv+(GA*0.4))*5.0);	
	A4 = 1.0-(A*0.8);
	N4 = smoothstep(0.9998,1.0,F4)*0.5*A4;	
            
    F5 = 1.0-cellular2x2((In.Uv+(GA*0.5))*4.0);	
	A5 = 1.0-(A*0.8);
	N5 = smoothstep(0.9998,1.0,F5)*0.6*A5;	
								
    F6 = 1.0-cellular2x2((In.Uv+(GA*0.8))*3.0);	
	A6 = 1.0-(A*0.8);
	N6 = smoothstep(0.9999,1.0,F6)*0.59*A6;
    
    F7 = 1.0-cellular2x2((In.Uv+(GA*1.2))*2.9);	
	A7 = 1.0-(A*0.8);
	N7 = smoothstep(0.9999,1.0,F7)*0.58*A7;
    
    F8 = 1.0-cellular2x2((In.Uv+(GA*1.8))*2.8);	
	A8 = 1.0-(A*0.8);
	N8 = smoothstep(0.9999,1.0,F8)*0.57*A8;
       
	float cl= N8+N7+N6+N5+N4+N3+N2+N1;
		
		 
	 //     In.Uv = floor(In.Uv * (pixelSize*10.0))/(pixelSize*10.0);
		         
        //    Out.Color = Texture0.Sample(Tex0, In.Uv)* In.Tint;
		
		Out.Color = float4(cl,cl,cl,1.0)*2.0;
			 
	return Out;
}

 