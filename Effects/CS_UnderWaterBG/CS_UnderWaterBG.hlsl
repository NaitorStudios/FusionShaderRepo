
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> Tex0 : register(t1);
sampler Tex0Sampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float fBlur;
	float fAmplitudeX;
	float fPeriodsX;
	float fFreqX;
	float fAmplitudeY;
	float fPeriodsY;
	float fFreqY;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
	// Output pixel
    PS_OUTPUT Out;
	//SinX
	In.texCoord.y = In.texCoord.y + (sin((In.texCoord.x+fFreqX)*fPeriodsX)*fAmplitudeX);// + 1.0f)%1.0f;
	//SinY
	In.texCoord.x = In.texCoord.x + (sin((In.texCoord.y+fFreqY)*fPeriodsY)*fAmplitudeY);// + 1.0f)%1.0f;

    // Output pixel
    PS_OUTPUT TexTL;
    PS_OUTPUT TexBL;
    PS_OUTPUT TexBR;
    PS_OUTPUT TexTR;
	TexTL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fBlur,In.texCoord.y-fBlur));
	TexBL.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x-fBlur,In.texCoord.y+fBlur));
	TexBR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fBlur,In.texCoord.y+fBlur));
	TexTR.Color = Tex0.Sample(Tex0Sampler, float2(In.texCoord.x+fBlur,In.texCoord.y-fBlur));
	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord.xy);
	
	Out.Color = (Out.Color+TexTL.Color+TexBL.Color+TexBR.Color+TexTR.Color)/5;
	Out.Color *= In.Tint;

    return Out;
}

float4 GetColorPM(float2 xy)
{
	float4 color = Tex0.Sample(Tex0Sampler, xy);
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
	// Output pixel
    PS_OUTPUT Out;
	//SinX
	In.texCoord.y = In.texCoord.y + (sin((In.texCoord.x+fFreqX)*fPeriodsX)*fAmplitudeX);// + 1.0f)%1.0f;
	//SinY
	In.texCoord.x = In.texCoord.x + (sin((In.texCoord.y+fFreqY)*fPeriodsY)*fAmplitudeY);// + 1.0f)%1.0f;

    // Output pixel
    PS_OUTPUT TexTL;
    PS_OUTPUT TexBL;
    PS_OUTPUT TexBR;
    PS_OUTPUT TexTR;
	TexTL.Color = GetColorPM(float2(In.texCoord.x-fBlur,In.texCoord.y-fBlur));
	TexBL.Color = GetColorPM(float2(In.texCoord.x-fBlur,In.texCoord.y+fBlur));
	TexBR.Color = GetColorPM(float2(In.texCoord.x+fBlur,In.texCoord.y+fBlur));
	TexTR.Color = GetColorPM(float2(In.texCoord.x+fBlur,In.texCoord.y-fBlur));
	Out.Color = GetColorPM(In.texCoord.xy);
	
	Out.Color = (Out.Color+TexTL.Color+TexBL.Color+TexBR.Color+TexTR.Color)/5;
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;

    return Out;
}
