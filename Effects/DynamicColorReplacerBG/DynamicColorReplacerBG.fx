sampler2D img : register(s1) = sampler_state
{
      MinFilter = Point;
      MagFilter = Point;
};

float4 from1, from2, from3, from4, from5, from6, from7, from8, from9, from10,
    from11, from12, from13, from14, from15;//, from16, from17, from18, from19, from20;
float4 to1, to2, to3, to4, to5, to6, to7, to8, to9, to10,
    to11, to12, to13, to14, to15;//, to16, to17, to18, to19, to20;

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
    float4 o = tex2D(img,In);
    return o;
}

float4 pass_1(in float2 In : TEXCOORD0) : COLOR0
{
    float4 o = tex2D(img,In);

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
    float4 o = tex2D(img,In);

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
    float4 o = tex2D(img,In);

    if (unequal(o, from11.rgb, to11.rgb) &&
        unequal(o, from12.rgb, to12.rgb) &&
        unequal(o, from13.rgb, to13.rgb) &&
        unequal(o, from14.rgb, to14.rgb) &&
        unequal(o, from15.rgb, to15.rgb)) {
        o.a = 0.0;
    }

    return o;
}

// float4 pass_4(in float2 In : TEXCOORD0) : COLOR0
// {
//     float4 o = tex2D(img,In);

//     if (unequal(o, from16.rgb, to16.rgb) &&
//         unequal(o, from17.rgb, to17.rgb) &&
//         unequal(o, from18.rgb, to18.rgb) &&
//         unequal(o, from19.rgb, to19.rgb) &&
//         unequal(o, from20.rgb, to20.rgb)) {
//         o.a = 0.0;
//     }

//     return o;
// }



technique tech_main {
    pass { PixelShader = compile ps_2_0 pass_0(); }
    pass { PixelShader = compile ps_2_0 pass_1(); }
    pass { PixelShader = compile ps_2_0 pass_2(); }
    pass { PixelShader = compile ps_2_0 pass_3(); }
    //pass { PixelShader = compile ps_2_0 pass_4(); }
}