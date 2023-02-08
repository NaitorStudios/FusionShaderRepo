Texture2D<float4> Texture0 : register(t0);
sampler TextureSampler0 : register(s0);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
	float oRadius;
	float oExponent;
	float4 oColor;
	float oAlpha;
	float iRadius;
	float iExponent;
	float4 iColor;
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

float4 ps_main(PS_INPUT In) : SV_TARGET
{
	int i;
	float glow;
    float4 fore = Texture0.Sample(TextureSampler0,In.texCoord) * In.Tint;
    
    //Inner glow
    glow = fore.a;
    for(i=0;i<12;i++)
	{
        glow += Texture0.Sample(TextureSampler0,In.texCoord+iRadius*float2(fPixelWidth,fPixelHeight)*offsets[i]).a * In.Tint.a;
	}
    glow /= 13;
    
	//Blend between to glow color based on blurred alpha
	fore.rgb = lerp(iColor.rgb,fore.rgb,pow(abs(glow),iExponent));

    //Outer glow
   	glow = fore.a;
    for(i=0;i<12;i++)
        glow += Texture0.Sample(TextureSampler0,In.texCoord+oRadius*float2(fPixelWidth,fPixelHeight)*offsets[i]).a * In.Tint.a;
    glow /= 13;
	
	//Fill transparent areas with the glow color
	fore.rgb = lerp(oColor.rgb,fore.rgb,fore.a);
	fore.a = max((1-pow(abs(1-glow),oExponent))*oAlpha,fore.a);
	
    return fore;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
	int i;
	float glow;
    float4 fore = Texture0.Sample(TextureSampler0,In.texCoord) * In.Tint;
	if ( fore.a != 0 )
		fore.rgb /= fore.a;

    //Inner glow
    glow = fore.a;
    for(i=0;i<12;i++)
	{
        glow += Texture0.Sample(TextureSampler0,In.texCoord+iRadius*float2(fPixelWidth,fPixelHeight)*offsets[i]).a * In.Tint.a;
	}
    glow /= 13;
    
	//Blend between to glow color based on blurred alpha
	fore.rgb = lerp(iColor.rgb,fore.rgb,pow(abs(glow),iExponent));

    //Outer glow
   	glow = fore.a;
    for(i=0;i<12;i++)
        glow += Texture0.Sample(TextureSampler0,In.texCoord+oRadius*float2(fPixelWidth,fPixelHeight)*offsets[i]).a * In.Tint.a;
    glow /= 13;
	
	//Fill transparent areas with the glow color
	fore.rgb = lerp(oColor.rgb,fore.rgb,fore.a);

	fore.a = max((1-pow(abs(1-glow),oExponent))*oAlpha,fore.a);
	fore.rgb *= fore.a;
	
    return fore;
}
