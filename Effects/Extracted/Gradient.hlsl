
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
Texture2D<float4> Texture0 : register(t0);
sampler Texture0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float4 fArgb  = 1;
	float fAa     = 1;
	float4 fBrgb  = 1;
	float fBa     = 0;
	float fOffset = 0;
	float fCoeff  = 1;
	float fFade   = 1;
	int iT        = 0;
	int iF        = 0;
	int iR        = 0;
	int iMask     = 0;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
	float Temp;
	float Gx;
	float Gy;
	float Ga;
	float3 Gcol;

	// Output pixel
    PS_OUTPUT Out;
    Gx = In.texCoord.x;
    Gy = In.texCoord.y;
    if(iF==1) {
    Gx = 1-Gx;
    Gy = 1-Gy;
    }
    if(iR==1) {
    Temp = Gy;
    Gy = Gx;
    Gx = Temp;
    }
    Out.Color = Texture0.Sample(Texture0Sampler,In.texCoord.xy) * In.Tint;
    //GRADIENT TYPES
    if(iT==0) {
    Gcol = fArgb.rgb+(fBrgb.rgb-fArgb.rgb)*(Gx+fOffset)*fCoeff;
    Ga = fAa+(fBa-fAa)*(Gx+fOffset)*fCoeff;
    }
    if(iT==1) {
    if(iR==1) Temp = 1-Gx; else Temp = Gx;
    Gcol = fArgb.rgb+(fBrgb.rgb-fArgb.rgb)*(Gy*Temp+fOffset)*fCoeff;
    Ga = fAa+(fBa-fAa)*(Gy*Temp+fOffset)*fCoeff;
    }  
    if(iT==2) {
    Gcol = fArgb.rgb+(fBrgb.rgb-fArgb.rgb)*abs(sin(Gx*fCoeff+fOffset));
    Ga = fAa+(fBa-fAa)*abs(sin(Gx*fCoeff+fOffset));
    } 
    if(iMask==1) Out.Color.a *= Ga;
    else Out.Color.a = Ga;
    Out.Color.rgb += (Gcol-Out.Color.rgb)*fFade;
    return Out;
}

float4 GetColorPM(float2 xy, float4 tint)
{
	float4 color = Texture0.Sample(Texture0Sampler, xy) * tint;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
	float Temp;
	float Gx;
	float Gy;
	float Ga;
	float3 Gcol;

	// Output pixel
    PS_OUTPUT Out;
    Gx = In.texCoord.x;
    Gy = In.texCoord.y;
    if(iF==1) {
    Gx = 1-Gx;
    Gy = 1-Gy;
    }
    if(iR==1) {
    Temp = Gy;
    Gy = Gx;
    Gx = Temp;
    }
    Out.Color = GetColorPM(In.texCoord.xy, In.Tint);
    //GRADIENT TYPES
    if(iT==0) {
    Gcol = fArgb.rgb+(fBrgb.rgb-fArgb.rgb)*(Gx+fOffset)*fCoeff;
    Ga = fAa+(fBa-fAa)*(Gx+fOffset)*fCoeff;
    }
    if(iT==1) {
    if(iR==1) Temp = 1-Gx; else Temp = Gx;
    Gcol = fArgb.rgb+(fBrgb.rgb-fArgb.rgb)*(Gy*Temp+fOffset)*fCoeff;
    Ga = fAa+(fBa-fAa)*(Gy*Temp+fOffset)*fCoeff;
    }  
    if(iT==2) {
    Gcol = fArgb.rgb+(fBrgb.rgb-fArgb.rgb)*abs(sin(Gx*fCoeff+fOffset));
    Ga = fAa+(fBa-fAa)*abs(sin(Gx*fCoeff+fOffset));
    } 
    if(iMask==1) Out.Color.a *= Ga;
    else Out.Color.a = Ga;
    Out.Color.rgb += (Gcol-Out.Color.rgb)*fFade;
	Out.Color.rgb *= Out.Color.a;
    return Out;
}
