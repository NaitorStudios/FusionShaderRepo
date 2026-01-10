sampler2D img = sampler_state
{
      MinFilter = Point;
      MagFilter = Point;
};

sampler2D bkd : register(s1);

float4 from1, from2, from3, from4, from5, from6, from7, from8, from9, from10,
    from11, from12, from13, from14, from15, from16, from17, from18, from19, from20,
	from21, from22, from23, from24, from25, from26, from27, from28, from29, from30,
    from31, from32, from33, from34, from35, from36, from37, from38, from39, from40,
	from41, from42, from43, from44, from45, from46, from47, from48, from49, from50,
    from51, from52, from53, from54, from55, from56, from57, from58, from59, from60;
float4 to1, to2, to3, to4, to5, to6, to7, to8, to9, to10,
    to11, to12, to13, to14, to15, to16, to17, to18, to19, to20,
	to21, to22, to23, to24, to25, to26, to27, to28, to29, to30,
    to31, to32, to33, to34, to35, to36, to37, to38, to39, to40,
	to41, to42, to43, to44, to45, to46, to47, to48, to49, to50,
    to51, to52, to53, to54, to55, to56, to57, to58, to59, to60;

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

float4 pass_0(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);
    return o;
}

float4 pass_1(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);	

    if (unequal(o, from1.rgb, to1.rgb) &&
        unequal(o, from2.rgb, to2.rgb) &&
        unequal(o, from3.rgb, to3.rgb) &&
        unequal(o, from4.rgb, to4.rgb) &&
        unequal(o, from5.rgb, to5.rgb)) {
        o.a = 0.0;
    }

    return o;
}

float4 pass_2(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if (unequal(o, from6.rgb, to6.rgb) &&
        unequal(o, from7.rgb, to7.rgb) &&
        unequal(o, from8.rgb, to8.rgb) &&
        unequal(o, from9.rgb, to9.rgb) &&
        unequal(o, from10.rgb, to10.rgb)) {
        o.a = 0.0;
    }

    return o;
}


float4 pass_3(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if (unequal(o, from11.rgb, to11.rgb) &&
        unequal(o, from12.rgb, to12.rgb) &&
        unequal(o, from13.rgb, to13.rgb) &&
        unequal(o, from14.rgb, to14.rgb) &&
        unequal(o, from15.rgb, to15.rgb)) {
        o.a = 0.0;
    }

    return o;
}

float4 pass_4(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if (unequal(o, from16.rgb, to16.rgb) &&
         unequal(o, from17.rgb, to17.rgb) &&
         unequal(o, from18.rgb, to18.rgb) &&
         unequal(o, from19.rgb, to19.rgb) &&
         unequal(o, from20.rgb, to20.rgb)) {
         o.a = 0.0;
    }

    return o;
}

float4 pass_5(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if  (unequal(o, from21.rgb, to21.rgb) &&
         unequal(o, from22.rgb, to22.rgb) &&
         unequal(o, from23.rgb, to23.rgb) &&
         unequal(o, from24.rgb, to24.rgb) &&
         unequal(o, from25.rgb, to25.rgb)) {
         o.a = 0.0;
    }

    return o;
}

float4 pass_6(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if  (unequal(o, from26.rgb, to26.rgb) &&
         unequal(o, from27.rgb, to27.rgb) &&
         unequal(o, from28.rgb, to28.rgb) &&
         unequal(o, from29.rgb, to29.rgb) &&
         unequal(o, from30.rgb, to30.rgb)) {
         o.a = 0.0;
    }

    return o;
}

float4 pass_7(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if (unequal(o, from31.rgb, to31.rgb) &&
        unequal(o, from32.rgb, to32.rgb) &&
        unequal(o, from33.rgb, to33.rgb) &&
        unequal(o, from34.rgb, to34.rgb) &&
        unequal(o, from35.rgb, to35.rgb)) {
        o.a = 0.0;
    }

    return o;
}

float4 pass_8(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

     if (unequal(o, from36.rgb, to36.rgb) &&
         unequal(o, from37.rgb, to37.rgb) &&
         unequal(o, from38.rgb, to38.rgb) &&
         unequal(o, from39.rgb, to39.rgb) &&
         unequal(o, from40.rgb, to40.rgb)) {
         o.a = 0.0;
     }

    return o;
}

float4 pass_9(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if (unequal(o, from41.rgb, to41.rgb) &&
        unequal(o, from42.rgb, to42.rgb) &&
        unequal(o, from43.rgb, to43.rgb) &&
        unequal(o, from44.rgb, to44.rgb) &&
        unequal(o, from45.rgb, to45.rgb)) {
        o.a = 0.0;
    }

    return o;
}

float4 pass_10(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

     if (unequal(o, from46.rgb, to46.rgb) &&
         unequal(o, from47.rgb, to47.rgb) &&
         unequal(o, from48.rgb, to48.rgb) &&
         unequal(o, from49.rgb, to49.rgb) &&
         unequal(o, from50.rgb, to50.rgb)) {
         o.a = 0.0;
     }

    return o;
}

float4 pass_11(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

    if (unequal(o, from51.rgb, to51.rgb) &&
        unequal(o, from52.rgb, to52.rgb) &&
        unequal(o, from53.rgb, to53.rgb) &&
        unequal(o, from54.rgb, to54.rgb) &&
        unequal(o, from55.rgb, to55.rgb)) {
        o.a = 0.0;
    }

    return o;
}

float4 pass_12(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(bkd,In);

     if (unequal(o, from56.rgb, to56.rgb) &&
         unequal(o, from57.rgb, to57.rgb) &&
         unequal(o, from58.rgb, to58.rgb) &&
         unequal(o, from59.rgb, to59.rgb) &&
         unequal(o, from60.rgb, to60.rgb)) {
         o.a = 0.0;
     }

    return o;
}



technique tech_main {
    pass { PixelShader = compile ps_2_0 pass_0(); }
    pass { PixelShader = compile ps_2_0 pass_1(); }
    pass { PixelShader = compile ps_2_0 pass_2(); }
    pass { PixelShader = compile ps_2_0 pass_3(); }
    pass { PixelShader = compile ps_2_0 pass_4(); }
	pass { PixelShader = compile ps_2_0 pass_5(); }
	pass { PixelShader = compile ps_2_0 pass_6(); }
	pass { PixelShader = compile ps_2_0 pass_7(); }
	pass { PixelShader = compile ps_2_0 pass_8(); }
	pass { PixelShader = compile ps_2_0 pass_9(); }
	pass { PixelShader = compile ps_2_0 pass_10(); }
	pass { PixelShader = compile ps_2_0 pass_11(); }
	pass { PixelShader = compile ps_2_0 pass_12(); }
}