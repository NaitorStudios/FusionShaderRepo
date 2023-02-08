
//---- Pixel shader input structure ----//
struct PS_INPUT
{
float4 Tint : COLOR0;
float2 texCoord : TEXCOORD0;
float4 Position : SV_POSITION;
};

//---- Pixel shader output structure ---//
struct PS_OUTPUT
{
  float4 Color   : SV_TARGET;
};

//--- Samplers ---//
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

//--- Global variables ---//
PS_OUTPUT ps_main( in PS_INPUT In ) {
	// Output pixel
	PS_OUTPUT Out;
	float4 bg = bkd.Sample(bkdSampler,In.texCoord);
	float4 fg = Tex0.Sample(Tex0Sampler,In.texCoord) * In.Tint;
	Out.Color.r = (int(bg.r*255)|int(fg.r*255))/255.0f;
	Out.Color.g = (int(bg.g*255)|int(fg.g*255))/255.0f;
	Out.Color.b = (int(bg.b*255)|int(fg.b*255))/255.0f;
	Out.Color.a = fg.a;
	return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In ) {
	// Output pixel
	PS_OUTPUT Out;
	float4 bg = bkd.Sample(bkdSampler,In.texCoord);
	float4 fg = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord)) * In.Tint;
	Out.Color.r = (int(bg.r*255)|int(fg.r*255))/255.0f;
	Out.Color.g = (int(bg.g*255)|int(fg.g*255))/255.0f;
	Out.Color.b = (int(bg.b*255)|int(fg.b*255))/255.0f;
	Out.Color.a = fg.a;
	Out.Color.rgb *= Out.Color.a;
	return Out;
}