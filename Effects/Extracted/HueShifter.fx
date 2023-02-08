float HueShift;

sampler2D Samp : TEXTURE0;
#define QUAD_REAL float
#define QUAD_REAL3 float3

QUAD_REAL3 rgb_to_hsv_no_clip(QUAD_REAL3 RGB)
{
    QUAD_REAL3 HSV;
    
 float minChannel, maxChannel;
 if (RGB.x > RGB.y) {
  maxChannel = RGB.x;
  minChannel = RGB.y;
 }
 else {
  maxChannel = RGB.y;
  minChannel = RGB.x;
 }
 
 if (RGB.z > maxChannel) maxChannel = RGB.z;
 if (RGB.z < minChannel) minChannel = RGB.z;
    
    HSV.xy = 0;
    HSV.z = maxChannel;
    QUAD_REAL delta = maxChannel - minChannel;             //Delta RGB value 
    if (delta != 0) {                    // If gray, leave H & S at zero
       HSV.y = delta / HSV.z;
       QUAD_REAL3 delRGB;
       delRGB = (HSV.zzz - RGB + 3*delta) / (6.0*delta);
       if      ( RGB.x == HSV.z ) HSV.x = delRGB.z - delRGB.y;
       else if ( RGB.y == HSV.z ) HSV.x = ( 1.0/3.0) + delRGB.x - delRGB.z;
       else if ( RGB.z == HSV.z ) HSV.x = ( 2.0/3.0) + delRGB.y - delRGB.x;
    }
    return (HSV);
}

QUAD_REAL3 hsv_to_rgb(QUAD_REAL3 HSV)
{
    QUAD_REAL3 RGB = HSV.z;
    //if ( HSV.y != 0 ) { // we don't really need this since it just adds an obsolete instruction slot
       QUAD_REAL var_h = HSV.x * 6;
       QUAD_REAL var_i = floor(var_h);   // Or ... var_i = floor( var_h )
       QUAD_REAL var_1 = HSV.z * (1.0 - HSV.y);
       QUAD_REAL var_2 = HSV.z * (1.0 - HSV.y * (var_h-var_i));
       QUAD_REAL var_3 = HSV.z * (1.0 - HSV.y * (1-(var_h-var_i)));
       if      (var_i == 0) { RGB = QUAD_REAL3(HSV.z, var_3, var_1); }
       else if (var_i == 1) { RGB = QUAD_REAL3(var_2, HSV.z, var_1); }
       else if (var_i == 2) { RGB = QUAD_REAL3(var_1, HSV.z, var_3); }
       else if (var_i == 3) { RGB = QUAD_REAL3(var_1, var_2, HSV.z); }
       else if (var_i == 4) { RGB = QUAD_REAL3(var_3, var_1, HSV.z); }
       else                 { RGB = QUAD_REAL3(HSV.z, var_1, var_2); }
   //}
   return (RGB);
}

float4 main(float2 uv : TEXCOORD) : COLOR
{
 float4 col = tex2D(Samp, uv);
 float3 hsv = rgb_to_hsv_no_clip(col.xyz);
    hsv.x+=HueShift;
    //if ( hsv.x > 1.0 ) { hsv.x -= 1.0; }
    hsv.x = frac(hsv.x);
    return float4(hsv_to_rgb(hsv),col.w);
}

// Techniques
technique PostProcess
{
    pass pass0
    {
        PixelShader = compile ps_2_0 main();
    }
}