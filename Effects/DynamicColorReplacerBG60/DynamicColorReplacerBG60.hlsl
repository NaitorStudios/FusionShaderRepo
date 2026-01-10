struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float4 from1, to1, from2, to2, from3, to3, from4, to4, from5, to5, from6, to6, from7, to7, from8, to8, from9, to9,
	from10, to10, from11, to11, from12, to12, from13, to13, from14, to14, from15, to15, from16, to16, from17, to17,
	from18, to18, from19, to19, from20, to20, from21, to21, from22, to22, from23, to23, from24, to24, from25, to25,
	from26, to26, from27, to27, from28, to28, from29, to29, from30, to30, from31, to31, from32, to32, from33, to33, from34,
	to34, from35, to35, from36, to36, from37, to37, from38, to38, from39, to39, from40, to40, from41, to41, from42, to42,
	from43, to43, from44, to44, from45, to45, from46, to46, from47, to47, from48, to48, from49, to49, from50, to50,
	from51, to51, from52, to52, from53, to53, from54, to54, from55, to55, from56, to56, from57, to57, from58, to58,
	from59, to59, from60, to60;
}

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
    float4 o = Demultiply(bkd.Sample(bkdSampler, In.texCoord) * In.Tint);
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
        unequal(o, from15.rgb, to15.rgb) &&
        unequal(o, from16.rgb, to16.rgb) &&
        unequal(o, from17.rgb, to17.rgb) &&
        unequal(o, from18.rgb, to18.rgb) &&
        unequal(o, from19.rgb, to19.rgb) &&
        unequal(o, from20.rgb, to20.rgb) &&
        unequal(o, from21.rgb, to21.rgb) &&
        unequal(o, from22.rgb, to22.rgb) &&
        unequal(o, from23.rgb, to23.rgb) &&
        unequal(o, from24.rgb, to24.rgb) &&
        unequal(o, from25.rgb, to25.rgb) &&
        unequal(o, from26.rgb, to26.rgb) &&
        unequal(o, from27.rgb, to27.rgb) &&
        unequal(o, from28.rgb, to28.rgb) &&
        unequal(o, from29.rgb, to29.rgb) &&
        unequal(o, from30.rgb, to30.rgb) &&
		unequal(o, from31.rgb, to31.rgb) &&
        unequal(o, from32.rgb, to32.rgb) &&
        unequal(o, from33.rgb, to33.rgb) &&
        unequal(o, from34.rgb, to34.rgb) &&
        unequal(o, from35.rgb, to35.rgb) &&
		unequal(o, from36.rgb, to36.rgb) &&
        unequal(o, from37.rgb, to37.rgb) &&
        unequal(o, from38.rgb, to38.rgb) &&
        unequal(o, from39.rgb, to39.rgb) &&
        unequal(o, from40.rgb, to40.rgb) &&
		unequal(o, from41.rgb, to41.rgb) &&
        unequal(o, from42.rgb, to42.rgb) &&
        unequal(o, from43.rgb, to43.rgb) &&
        unequal(o, from44.rgb, to44.rgb) &&
        unequal(o, from45.rgb, to45.rgb) &&
        unequal(o, from46.rgb, to46.rgb) &&
        unequal(o, from47.rgb, to47.rgb) &&
        unequal(o, from48.rgb, to48.rgb) &&
        unequal(o, from49.rgb, to49.rgb) &&
        unequal(o, from50.rgb, to50.rgb) &&
        unequal(o, from51.rgb, to51.rgb) &&
        unequal(o, from52.rgb, to52.rgb) &&
        unequal(o, from53.rgb, to53.rgb) &&
        unequal(o, from54.rgb, to54.rgb) &&
        unequal(o, from55.rgb, to55.rgb) &&
        unequal(o, from56.rgb, to56.rgb) &&
        unequal(o, from57.rgb, to57.rgb) &&
        unequal(o, from58.rgb, to58.rgb) &&
        unequal(o, from59.rgb, to59.rgb) &&
        unequal(o, from60.rgb, to60.rgb))
		{
		//This makes any unchanged color invisible.
        //o.a = 0.0;
    }
	o.rgb *= o.a;

    return o;

}
