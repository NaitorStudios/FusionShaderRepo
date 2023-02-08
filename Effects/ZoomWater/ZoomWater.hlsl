
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
Texture2D<float4> Tex0 : register(t0);
sampler TexSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fBlur;
	float fAmplitudeX;
	float fPeriodsX;
	float fFreqX;
	float fAmplitudeY;
	float fPeriodsY;
	float fFreqY;
};


PS_OUTPUT ps_main( in PS_INPUT In )
{
	// Output pixel
    PS_OUTPUT Out;
	//SinX
	In.texCoord.y = (In.texCoord.y-0.5)*2+0.5 + (sin((In.texCoord.x+fFreqX)*fPeriodsX)*fAmplitudeX);
	//SinY
	In.texCoord.x = (In.texCoord.x-0.5)*2+0.5 + (sin((In.texCoord.y+fFreqY)*fPeriodsY)*fAmplitudeY);

    // Output pixel
	if (abs(In.texCoord.x - 0.5) >= 0.5 || abs(In.texCoord.y - 0.5) >= 0.5){
	 Out.Color = 0;
	} else {
    PS_OUTPUT TexTL;
    PS_OUTPUT TexBL;
    PS_OUTPUT TexBR;
    PS_OUTPUT TexTR;
	TexTL.Color = Tex0.Sample(TexSampler0, float2(In.texCoord.x-fBlur,In.texCoord.y-fBlur));
	TexBL.Color = Tex0.Sample(TexSampler0, float2(In.texCoord.x-fBlur,In.texCoord.y+fBlur));
	TexBR.Color = Tex0.Sample(TexSampler0, float2(In.texCoord.x+fBlur,In.texCoord.y+fBlur));
	TexTR.Color = Tex0.Sample(TexSampler0, float2(In.texCoord.x+fBlur,In.texCoord.y-fBlur));
	Out.Color = Tex0.Sample(TexSampler0, In.texCoord.xy);
	Out.Color = (Out.Color+TexTL.Color+TexBL.Color+TexBR.Color+TexTR.Color)/5;
	}
	Out.Color *= In.Tint;
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
	// Output pixel
    PS_OUTPUT Out;
	//SinX
	In.texCoord.y = (In.texCoord.y-0.5)*2+0.5 + (sin((In.texCoord.x+fFreqX)*fPeriodsX)*fAmplitudeX);
	//SinY
	In.texCoord.x = (In.texCoord.x-0.5)*2+0.5 + (sin((In.texCoord.y+fFreqY)*fPeriodsY)*fAmplitudeY);

    // Output pixel
	if (abs(In.texCoord.x - 0.5) >= 0.5 || abs(In.texCoord.y - 0.5) >= 0.5){
	 Out.Color = 0;
	} else {
	Out.Color = (Tex0.Sample(TexSampler0, float2(In.texCoord.x-fBlur,In.texCoord.y-fBlur)) + Tex0.Sample(TexSampler0, float2(In.texCoord.x-fBlur,In.texCoord.y+fBlur)) + Tex0.Sample(TexSampler0, float2(In.texCoord.x+fBlur,In.texCoord.y+fBlur)) + Tex0.Sample(TexSampler0, float2(In.texCoord.x+fBlur,In.texCoord.y-fBlur)) + Tex0.Sample(TexSampler0, In.texCoord.xy)) / 5;
	if ( Out.Color.a != 0 ){
		Out.Color.rgb /= Out.Color.a;
	}
	}
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
    return Out;
}