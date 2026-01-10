sampler2D bg_img : register (s1) = sampler_state {MinFilter = linear;	MagFilter = linear;};

#define PI 3.14159265359
#define PI_2 1.57079632679
#define PI2 6.28318530718

float fovVar;
float latitudeVar;
float longitudeVar;

struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

float con1(float long_lat, float deg){
	return (long_lat/deg);
}

float con2(float num){
	return ((num/2.)-0.5);
}

float2 project(in float2 uv, in float2 m, in float2 fov) {
    float2 m2 = (m * 2.0 - 1.0) * float2(PI, PI_2);
    float2 cuv = (uv * 2.0 - 1.0) * fov * float2(PI, PI_2); 
    float x = cuv.x;
    float y = cuv.y;
    float rou = sqrt(x * x + y * y), c = atan(rou); 
	float sin_c = sin( c ), cos_c = cos( c);  
    float lat = asin(cos_c * sin(m2.y) + (y * sin_c * cos(m2.y)) / rou);
	float lon = m2.x + atan((x * sin_c)/ (rou * cos(m2.y) * cos_c - y * sin(m2.y) * sin_c));
	lat = (lat / PI_2 + 1.0) * 0.5; 
    lon = (lon / PI + 1.0) * 0.5;
   return (float2(lon, lat)) * float2(PI2, PI);
}

PS_OUTPUT ps_main( in PS_INPUT In) {
	PS_OUTPUT Out;
	float2 q = float2(In.Texture.x,In.Texture.y);
    float2 fov = fovVar; 
    float2 m = float2(0.5,0.5);
    float2 dir = project(q, m, fov) / (float2(PI2, PI));
 
    float2 ou;
    ou.x = con1(180.,longitudeVar);
    ou.y = con1(90.,latitudeVar);
 
    dir.x *= ou.x;
    dir.y *= ou.y;
    dir.x -= con2(ou.x);
    dir.y -= con2(ou.y); 

    Out.Color = tex2D(bg_img, dir);
    return Out;

}

technique tech_main
{
	pass P0
	{
		VertexShader = NULL;
		PixelShader = compile ps_2_a ps_main();
	}	
}