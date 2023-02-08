// http://www.gamerendering.com/2008/12/20/radial-blur-filter/
// Quickly ported for 

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float sampleStrength;
	int absolute;
	float sampleDist;
	float x;
	float y;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

static float samples[] = {-0.08,-0.05,-0.03,-0.02,-0.01,0.01,0.02,0.03,0.05,0.08};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float2 relative = 1.0;
	if(absolute)
		relative = float2(fPixelWidth,fPixelHeight);
	
	float2 dir = float2(x,y)*relative-In.texCoord;
	float dist = sqrt(dir.x*dir.x+dir.y*dir.y);
	dir /= dist;
	
    float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint, sum = color;
    
    for(int i =0; i<10 ; i++)
        sum += img.Sample(imgSampler, In.texCoord + dir*samples[i]*sampleDist*relative) * In.Tint;
    sum /= 11.0;
    
    float t = dist*sampleStrength;
    t = clamp(t,0,1);
    
    return lerp(color,sum,t);
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float2 relative = 1.0;
	if(absolute)
		relative = float2(fPixelWidth,fPixelHeight);
	
	float2 dir = float2(x,y)*relative-In.texCoord;
	float dist = sqrt(dir.x*dir.x+dir.y*dir.y);
	dir /= dist;
	
    float4 color = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	float4 sum = color;
    
    for(int i =0; i<10 ; i++)
	{
		float4 tmp = img.Sample(imgSampler, In.texCoord + dir*samples[i]*sampleDist*relative) * In.Tint;
		if ( tmp.a != 0 )
			tmp.rgb /= tmp.a;
        sum += tmp;
	}
    sum /= 11.0;
    
    float t = dist*sampleStrength;
    t = clamp(t,0,1);
    
    color = lerp(color,sum,t);
	color.rgb *= color.a;
	return color;
}
