struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

cbuffer PS_VARIABLES : register(b0)
{
	float HueShift;
}

Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

#define QUAD_REAL float
#define QUAD_REAL3 float3

float4 GetColorPM(float2 xy, float4 tint)
{
	float4 color = img.Sample(imgSampler, xy) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

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

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
 float4 col = img.Sample(imgSampler, In.texCoord) * In.Tint;
 float3 hsv = rgb_to_hsv_no_clip(col.xyz);
    hsv.x+=HueShift;
    //if ( hsv.x > 1.0 ) { hsv.x -= 1.0; }
    hsv.x = frac(hsv.x);
    return float4(hsv_to_rgb(hsv),col.w);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
 float4 col = GetColorPM(In.texCoord, In.Tint);
 float3 hsv = rgb_to_hsv_no_clip(col.xyz);
    hsv.x+=HueShift;
    //if ( hsv.x > 1.0 ) { hsv.x -= 1.0; }
    hsv.x = frac(hsv.x);
	
	float4 color = float4(hsv_to_rgb(hsv),col.w);
	color.rgb *= color.a;
	
    return color;
}
