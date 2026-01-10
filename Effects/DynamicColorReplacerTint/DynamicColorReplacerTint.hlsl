struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

//Not sure how to port this part.
//sampler2D img = sampler_state
//{
//      MinFilter = Point;
//      MagFilter = Point;
//};

cbuffer PS_VARIABLES : register(b0)
{
float4 from1, to1, from2, to2, from3, to3, from4, to4, from5, to5, from6, to6, from7, to7, from8, to8, from9, to9, from10, to10,
    from11, to11, from12, to12, from13, to13, from14, to14, from15, to15;//, from16, from17, from18, from19, from20;
float4 Tint;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}


#define THRESHOLD (0.33/255)

bool unequal(inout float4 test, in float3 from, in float3 to)
{
    if (distance(test.rgb, from) < THRESHOLD) {
        test.rgb = to;
        return false;
    }
    else {
        return true;
    }
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float4 o = Demultiply(img.Sample(imgSampler, In.texCoord) * In.Tint);
	if (unequal(o, from1.rgb, to1.rgb) &&
        unequal(o, from2.rgb, to2.rgb) &&
        unequal(o, from3.rgb, to3.rgb) &&
        unequal(o, from4.rgb, to4.rgb) &&
        unequal(o, from5.rgb, to5.rgb) &&
		unequal(o, from6.rgb, to6.rgb) &&
        unequal(o, from7.rgb, to7.rgb) &&
        unequal(o, from8.rgb, to8.rgb) &&
        unequal(o, from9.rgb, to9.rgb) &&
        unequal(o, from10.rgb, to10.rgb) &&
		unequal(o, from11.rgb, to11.rgb) &&
        unequal(o, from12.rgb, to12.rgb) &&
        unequal(o, from13.rgb, to13.rgb) &&
        unequal(o, from14.rgb, to14.rgb) &&
        unequal(o, from15.rgb, to15.rgb))
		{
		//This makes any unchanged color invisible.
        //o.a = 0.0;
    }
	o.rgb *= o.a;
	o.rgb *= Tint.rgb;
    return o;

}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    float4 o = Demultiply(img.Sample(imgSampler, In.texCoord) * In.Tint);
	if (unequal(o, from1.rgb, to1.rgb) &&
        unequal(o, from2.rgb, to2.rgb) &&
        unequal(o, from3.rgb, to3.rgb) &&
        unequal(o, from4.rgb, to4.rgb) &&
        unequal(o, from5.rgb, to5.rgb) &&
		unequal(o, from6.rgb, to6.rgb) &&
        unequal(o, from7.rgb, to7.rgb) &&
        unequal(o, from8.rgb, to8.rgb) &&
        unequal(o, from9.rgb, to9.rgb) &&
        unequal(o, from10.rgb, to10.rgb) &&
		unequal(o, from11.rgb, to11.rgb) &&
        unequal(o, from12.rgb, to12.rgb) &&
        unequal(o, from13.rgb, to13.rgb) &&
        unequal(o, from14.rgb, to14.rgb) &&
        unequal(o, from15.rgb, to15.rgb))
		{
		//This makes any unchanged color invisible.
        //o.a = 0.0;
    }
	o.rgb *= o.a;
	o.rgb *= Tint.rgb;
    return o;

}
