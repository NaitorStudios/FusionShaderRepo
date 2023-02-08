
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

cbuffer PS_VARIABLES : register(b0)
{
	float4 stencilColor;
	float tolerance;
}


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
	float4 fg = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord)) * In.Tint;

    float dist = (bg.r - stencilColor.r) * (bg.r - stencilColor.r) +
                 (bg.g - stencilColor.g) * (bg.g - stencilColor.g) +
                 (bg.b - stencilColor.b) * (bg.b - stencilColor.b);

    Out.Color.rgba = fg.rgba;
    if (dist > tolerance * tolerance)
      Out.Color.rgba = 0.0f;

    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In ) {
    // Output pixel
    PS_OUTPUT Out;
	float4 bg = bkd.Sample(bkdSampler,In.texCoord);
	float4 fg = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord)) * In.Tint;

    float dist = (bg.r - stencilColor.r) * (bg.r - stencilColor.r) +
                 (bg.g - stencilColor.g) * (bg.g - stencilColor.g) +
                 (bg.b - stencilColor.b) * (bg.b - stencilColor.b);

    Out.Color.rgba = fg.rgba;
    if (dist > tolerance * tolerance)
      Out.Color.rgba = 0.0f;

	Out.Color.rgb *= Out.Color.a;
    return Out;
}

