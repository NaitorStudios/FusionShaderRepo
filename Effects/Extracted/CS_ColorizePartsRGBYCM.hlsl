
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
	//Tint color
	float4 fR;
	float4 fG;
	float4 fB;
	float4 fY;
	float4 fC;
	float4 fP;
	float fCoeff;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Out.Color = Tex0.Sample(Tex0Sampler, In.texCoord);

	//Red
	if((fR.r>0.0f || fR.g>0.0f || fR.b>0.0f) && 
		Out.Color.r>0.0f && Out.Color.g<fCoeff && Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.r*fR.rgb;
	}
	//Green
	else if((fG.r>0.0f || fG.g>0.0f || fG.b>0.0f) && 
		Out.Color.g>0.0f &&	Out.Color.r<fCoeff && Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.g*fG.rgb;
	}
	//Blue
	else if((fB.r>0.0f || fB.g>0.0f || fB.b>0.0f) && 
		Out.Color.b>0.0f &&	Out.Color.r<fCoeff && Out.Color.g<fCoeff)
	{
		Out.Color.rgb = Out.Color.b*fB.rgb;
	}
	/*
	//Yellow
	else if((fY.r>0.0f || fY.g>0.0f || fY.b>0.0f) && 
		Out.Color.r>Out.Color.g-fCoeff && Out.Color.r<Out.Color.g+fCoeff &&	Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.r*fY.rgb;
	}
	//Cyan
	else if((fC.r>0.0f || fC.g>0.0f || fC.b>0.0f) && 
		Out.Color.g>Out.Color.b-fCoeff && Out.Color.g<Out.Color.b+fCoeff &&	Out.Color.r<fCoeff)
	{
		Out.Color.rgb = Out.Color.g*fC.rgb;
	}
	//Purple
	else if((fP.r>0.0f || fP.g>0.0f || fP.b>0.0f) && 
		Out.Color.r>Out.Color.b-fCoeff && Out.Color.r<Out.Color.b+fCoeff && Out.Color.g<fCoeff)
	{
		Out.Color.rgb = Out.Color.r*fP.rgb;
	}*/
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
	Out.Color = GetColorPM(In.texCoord);

	//Red
	if((fR.r>0.0f || fR.g>0.0f || fR.b>0.0f) && 
		Out.Color.r>0.0f && Out.Color.g<fCoeff && Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.r*fR.rgb;
	}
	//Green
	else if((fG.r>0.0f || fG.g>0.0f || fG.b>0.0f) && 
		Out.Color.g>0.0f &&	Out.Color.r<fCoeff && Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.g*fG.rgb;
	}
	//Blue
	else if((fB.r>0.0f || fB.g>0.0f || fB.b>0.0f) && 
		Out.Color.b>0.0f &&	Out.Color.r<fCoeff && Out.Color.g<fCoeff)
	{
		Out.Color.rgb = Out.Color.b*fB.rgb;
	}
	/*
	//Yellow
	else if((fY.r>0.0f || fY.g>0.0f || fY.b>0.0f) && 
		Out.Color.r>Out.Color.g-fCoeff && Out.Color.r<Out.Color.g+fCoeff &&	Out.Color.b<fCoeff)
	{
		Out.Color.rgb = Out.Color.r*fY.rgb;
	}
	//Cyan
	else if((fC.r>0.0f || fC.g>0.0f || fC.b>0.0f) && 
		Out.Color.g>Out.Color.b-fCoeff && Out.Color.g<Out.Color.b+fCoeff &&	Out.Color.r<fCoeff)
	{
		Out.Color.rgb = Out.Color.g*fC.rgb;
	}
	//Purple
	else if((fP.r>0.0f || fP.g>0.0f || fP.b>0.0f) && 
		Out.Color.r>Out.Color.b-fCoeff && Out.Color.r<Out.Color.b+fCoeff && Out.Color.g<fCoeff)
	{
		Out.Color.rgb = Out.Color.r*fP.rgb;
	}*/
	Out.Color.rgb *= Out.Color.a;
	Out.Color *= In.Tint;
	
    return Out;
}

