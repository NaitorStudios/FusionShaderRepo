sampler2D img;

const float HALF = 128.0/255;
float4 C000, C001, C002, C003, C004, C005, C006, C007, C008, C009, C010, C011, C012, C013, C014, C015, C016, C017, C018, C019, C020;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
float4 o = tex2D(img,In);
	
	if(o.r == 100.0/255.0)
		{
			o.rgb = C000.rgb;
		}
	if(o.r == 101.0/255.0)
		{
			o.rgb = C001.rgb;
		}
	if(o.r == 102.0/255.0)
		{
			o.rgb = C002.rgb;
		}
	if(o.r == 103.0/255.0)
		{
			o.rgb = C003.rgb;
		}
	if(o.r == 104.0/255.0)
		{
			o.rgb = C004.rgb;
		}
	if(o.r == 105.0/255.0)
		{
			o.rgb = C005.rgb;
		}
	if(o.r == 106.0/255.0)
		{
			o.rgb = C006.rgb;
		}
	if(o.r == 107.0/255.0)
		{
			o.rgb = C007.rgb;
		}
	if(o.r == 108.0/255.0)
		{
			o.rgb = C008.rgb;
		}
	if(o.r == 109.0/255.0)
		{
			o.rgb = C009.rgb;
		}
	if(o.r == 110.0/255.0)
		{
			o.rgb = C010.rgb;
		}
	if(o.r == 111.0/255.0)
		{
			o.rgb = C011.rgb;
		}
	if(o.r == 112.0/255.0)
		{
			o.rgb = C012.rgb;
		}
	if(o.r == 113.0/255.0)
		{
			o.rgb = C013.rgb;
		}
	if(o.r == 114.0/255.0)
		{
			o.rgb = C014.rgb;
		}
	if(o.r == 115.0/255.0)
		{
			o.rgb = C015.rgb;
		}
	if(o.r == 116.0/255.0)
		{
			o.rgb = C016.rgb;
		}
	if(o.r == 117.0/255.0)
		{
			o.rgb = C017.rgb;
		}
	if(o.r == 118.0/255.0)
		{
			o.rgb = C018.rgb;
		}
	if(o.r == 119.0/255.0)
		{
			o.rgb = C019.rgb;
		}
	if(o.r == 1.0/255.0)
		{
			o.rgb = C020.rgb;
		}
	
	return o;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}