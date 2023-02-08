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
	float radius;
	float exponent;
	float4 color;
	float xOffset;
	float yOffset;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

static const float2 offsets[12] = {
   -0.326212, -0.305805,
   -0.840144,  0.073580,
   -0.695914,  0.557137,
   -0.203345,  0.720716,
    0.962340, -0.094983,
    0.473434, -0.380026,
    0.519456,  0.867022,
    0.185461, -0.793124,
    0.507431,  0.164425,
    0.896420,  0.512458,
   -0.321940, -0.832615,
   -0.791559, -0.497705,
};

float4 ps_main(in PS_INPUT In) : SV_TARGET
{
	float4 fore = img.Sample(imgSampler,In.texCoord) * In.Tint;
    float blur = fore.a;
    
    //Blur the alpha channel
    for(int i=0;i<12;i++)
        blur += img.Sample(imgSampler,In.texCoord+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]+float2(xOffset, yOffset)).a * In.Tint.a;
    blur /= 13;
    
	//Blend between shadow color and foreground
	fore.rgb = lerp(color.rgb,fore.rgb,pow(abs(blur),exponent));
	
    return fore;
}

float4 ps_main_pm(in PS_INPUT In) : SV_TARGET
{
	float4 fore = img.Sample(imgSampler,In.texCoord) * In.Tint;
	if ( fore.a != 0 )
		fore.rgb /= fore.a;
    float blur = fore.a;
    
    //Blur the alpha channel
    for(int i=0;i<12;i++)
        blur += img.Sample(imgSampler,In.texCoord+radius*float2(fPixelWidth,fPixelHeight)*offsets[i]+float2(xOffset, yOffset)).a * In.Tint.a;
    blur /= 13;
    
	//Blend between shadow color and foreground
	fore.rgb = lerp(color.rgb,fore.rgb,pow(abs(blur),exponent)) * fore.a;
	
    return fore;
}

