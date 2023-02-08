
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
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float fRx;
	float fRy;
	float fGx;
	float fGy;
	float fBx;
	float fBy;
	float fAx;
	float fAy;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    PS_OUTPUT R;
    PS_OUTPUT G;
    PS_OUTPUT B;
    PS_OUTPUT A;
    R.Color = Tex0.Sample(Tex0Sampler,float2((In.texCoord.x+fRx)%1,(In.texCoord.y+fRy)%1));
    G.Color = Tex0.Sample(Tex0Sampler,float2((In.texCoord.x+fGx)%1,(In.texCoord.y+fGy)%1));
    B.Color = Tex0.Sample(Tex0Sampler,float2((In.texCoord.x+fBx)%1,(In.texCoord.y+fBy)%1));
    A.Color = Tex0.Sample(Tex0Sampler,float2((In.texCoord.x+fAx)%1,(In.texCoord.y+fAy)%1));
    Out.Color.r = R.Color.r;
    Out.Color.g = G.Color.g;
    Out.Color.b = B.Color.b;
    Out.Color.a = A.Color.a;
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
    PS_OUTPUT R;
    PS_OUTPUT G;
    PS_OUTPUT B;
    PS_OUTPUT A;
    R.Color = GetColorPM(float2((In.texCoord.x+fRx)%1,(In.texCoord.y+fRy)%1));
    G.Color = GetColorPM(float2((In.texCoord.x+fGx)%1,(In.texCoord.y+fGy)%1));
    B.Color = GetColorPM(float2((In.texCoord.x+fBx)%1,(In.texCoord.y+fBy)%1));
    A.Color = GetColorPM(float2((In.texCoord.x+fAx)%1,(In.texCoord.y+fAy)%1));
    Out.Color.r = R.Color.r;
    Out.Color.g = G.Color.g;
    Out.Color.b = B.Color.b;
    Out.Color.a = A.Color.a;
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
    return Out;
}
