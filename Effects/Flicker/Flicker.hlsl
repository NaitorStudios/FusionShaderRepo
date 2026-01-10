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

float tt;
float spd;
bool scl;
};

float3 rgb2hsv(float3 rgb)
{
	float Cmax = max(rgb.r, max(rgb.g, rgb.b));
	float Cmin = min(rgb.r, min(rgb.g, rgb.b));
    float delta = Cmax - Cmin;

	float3 hsv = float3(0., 0., Cmax);
	
	if (Cmax > Cmin)
	{
		hsv.y = delta / Cmax;

		if (rgb.r == Cmax)
			hsv.x = (rgb.g - rgb.b) / delta;
		else
		{
			if (rgb.g == Cmax)
				hsv.x = 2. + (rgb.b - rgb.r) / delta;
			else
				hsv.x = 4. + (rgb.r - rgb.g) / delta;
		}
		hsv.x = frac(hsv.x / 6.);
	}
	return hsv;
}

float chromaKey(float3 color)
{
	float3 backgroundColor = float3(0.157, 0.576, 0.129);
	float3 weights = float3(4., 1., 2.);

	float3 hsv = rgb2hsv(color);
	float3 target = rgb2hsv(backgroundColor);
	float dist = length(weights * (target - hsv));
	return 1. - clamp(3. * dist - 1.5, 0., 1.);
}

float3 makeBw(float3 i)
{
    return float3((i.r + i.g + i.b)/3.0, (i.r + i.g + i.b)/3.0, (i.r + i.g + i.b)/3.0);
}

//based on Mario scan line:

float3 Scanline(float3 color, float2 uv)
{
   float scanline    = clamp( 0.95 + 0.05 * cos( 3.14 * ( uv.y + 0.008 * tt) * 240.0 * 1.0 ), 0.0, 1.0 );
   float grille    = 0.85 + 0.15 * clamp( 1.5 * cos( 3.14 * uv.x * 640.0 * 1.0 ), 0.0, 1.0 );    
   return color * scanline * grille * 1.2;
}

//from tv flickering: https://www.shadertoy.com/view/4tSGzy

float rand(float2 seed) {
    float dotResult = dot(seed.xy, float2(12.9898,78.233));
    float sinxx = sin(dotResult) * 43758.5453;
    return frac(sinxx);
}


// float rand(in float2 uv)
// {
    // float2 noise = (frac(sin(dot(uv ,float2(12.9898,78.233)*2.0)) * 43758.5453));
    // return abs(noise.x + noise.y) * 0.5;
// }


float3 edgeSample(float2 uv) {   
   
  if(uv.x > 1.0) return float3(0.0,0.0,0.0);
  if(uv.x < 0.0) return float3(0.0,0.0,0.0);
  if(uv.y > 1.0) return float3(0.0,0.0,0.0);
  if(uv.y < 0.0) return float3(0.0,0.0,0.0);
  float3 c = Texture0.Sample(Tex0, clamp(uv,0.0,1.0)).rgb;
  float incrustation = chromaKey(c);
   
 // c = lerp(c, float3(0.0,0.0,0.0), 0.);// chroma not needed here !
  return c;
}
 

PS_OUTPUT ps_main( in PS_INPUT In )
{
             
    PS_OUTPUT Out;
       
            
              float2 flck =In.Uv;
			 // flck.y = 1.-flck.y;
			  
              flck.x += rand(float2(0,In.Uv.y)*tt)*spd ;
              flck.y += rand(float2(0,In.Uv.x)*tt)*spd ;
			  
			  float3 c = float3(0.0,0.0,0.0);
		if(scl)	 {
		
		c += Scanline(edgeSample(flck)*1.0, In.Uv);
		
		}
		 
         
		 c += edgeSample(flck);
		 
		 	 
			  
              Out.Color = float4(c,1.0);
 

	return Out;
}

 