//sampler2D fg;
sampler2D bg : register(s1) = sampler_state {
    AddressU = Clamp;
    AddressV = Clamp;
    //BorderColor = float4(0,0,0,0);
    MinFilter = Point;
    MagFilter = Point;
};
sampler2D image : register(s2) = sampler_state {
    AddressU = Wrap;
    AddressV = Wrap;
    MinFilter = Point;
    MagFilter = Point;
};
float offsetX,offsetY,width,height,fPixelWidth,fPixelHeight,texwidth,texheight;
int subsampling;
float biasX, biasY;
float l, r, b, t;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float2 shiftcoor = (In + float2(offsetX*fPixelWidth, offsetY*fPixelHeight)) / float2(fPixelWidth * texwidth, fPixelHeight * texheight);
	float4 shift = tex2D(image,shiftcoor);
	float2 off = float2(width*fPixelWidth,height*fPixelHeight);
	off.x *= 2*(shift.r-0.5-biasX*0.5);
	off.y *= 2*(shift.g-0.5-biasY*0.5);
	float4 o = tex2D(bg, In+off);
	if (subsampling == 1) {
		o += tex2D(bg,In+off+float2(fPixelWidth*0.20,0));
		o += tex2D(bg,In+off+float2(fPixelWidth*-0.20,0));
		o += tex2D(bg,In+off+float2(0,fPixelHeight*0.20));
		o += tex2D(bg,In+off+float2(0,fPixelHeight*-0.20));
		o /= 5;
	}
    float crop = 1.0;
    if (l > 0.001) crop = In.x / (l * fPixelWidth);
    if (r > 0.001) crop = min(crop, (1.0 - In.x) / (r * fPixelWidth));
    if (t > 0.001) crop = min(crop, In.y / (t * fPixelHeight));
    if (b > 0.001) crop = min(crop, (1.0 - In.y) / (b * fPixelHeight));

    // Hack to fix bordered Quick Backdrops 
//    if (tex2D(fg, float2(0.0, 0.0)).a == 0.0) {
//    if tex2D(fg, float2(0.0, 0.0)).a + tex2D(fg,float2(1.0/fPixelWidth, 0.0)).a + tex2D(fg,float2(0.0, 1.0/fPixelHeight)).a + tex2D(fg,float2(1.0/fPixelWidth, 1.0/fPixelHeight)).a) == 0.0) {

//        crop = 0.0;
//    }

    o.a *= max(0.0, min(1.0, crop));

	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}