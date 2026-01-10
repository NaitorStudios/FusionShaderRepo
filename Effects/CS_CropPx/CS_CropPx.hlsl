
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
	float fL;
	float fR;
	float fT;
	float fB;
	float fA;
};

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord);
	
	// Normalize the cropping values based on the object size
    float normL = fL * fPixelWidth;
    float normR = fR * fPixelWidth;
    float normT = fT * fPixelHeight;
    float normB = fB * fPixelHeight;
	
	if(In.texCoord.x<normL|| In.texCoord.x>1.0f-normR || In.texCoord.y<normT || In.texCoord.y>1.0f-normB)
	{
		Out.Color.a = Out.Color.a*fA;
	}
	Out.Color *= In.Tint;
	
    return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord);
	
	// Normalize the cropping values based on the object size
    float normL = fL * fPixelWidth;
    float normR = fR * fPixelWidth;
    float normT = fT * fPixelHeight;
    float normB = fB * fPixelHeight;
	
	if(In.texCoord.x<normL|| In.texCoord.x>1.0f-normR || In.texCoord.y<normT || In.texCoord.y>1.0f-normB)
	{
		Out.Color.a = Out.Color.a*fA;
		Out.Color.rgb = Out.Color.rgb*fA;
	}
	Out.Color *= In.Tint;
	
    return Out;
}

