sampler2D img ;
sampler2D bkd : register(s1);
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

float rez;
float div; 
float tt;
float sclx;
float scly;
float scla;
bool scl;
  

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
    float sin = sin(dotResult) * 43758.5453;
    return frac(sin);
}


float3 edgeSample(float2 uv) {   
   
 float3 c = tex2D(img, clamp(uv,0.0,1.0)).rgb;
  float incrustation = chromaKey(c);
   
  c = lerp(c, float3(0.0,0.0,0.0), 0.);// chroma not needed here !
  return c;
}
 

float4 ps_main(in float2 uv : TEXCOORD0, in PS_INPUT In) : COLOR0
{
             
              PS_OUTPUT Out;
           //   float4 color = tex2D(img,  uv+0.5);
 

             float2 flck = uv;
  
              flck.x += rand(float2(0,uv.y)*(tt)) * 1.0;
              flck.y += rand(float2(0,uv.x)*(tt)) * 1.0;
    
              float3 c = edgeSample(flck);
    
 

	return float4(c,1.0);
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}