// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Textures
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> fImage : register(t1);
sampler fImageSampler : register(s1);
Texture2D<float4> fBorderImage : register(t2);
sampler fBorderImageSampler : register(s2);
Texture2D<float4> fBackgroundImage : register(t3);
sampler fBackgroundImageSampler : register(s3);

// Global variables
cbuffer PS_VARIABLES : register(b0)
{
float fValue;
bool fBoolBorder;
bool fBoolBackground;
bool fBoolDraw;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    float4 Out;
    float4 gradient = fImage.Sample(fImageSampler, In.texCoord);
    float4 bg = fBackgroundImage.Sample(fBackgroundImageSampler, In.texCoord);
    float4 border = fBorderImage.Sample(fBorderImageSampler, In.texCoord);
    Out = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
    float result = (gradient.r + gradient.g + gradient.b)/3.0;
    if( result < 1.0 - fValue){
    if( fBoolBackground == true ){
    Out = bg;
    }
    else{
    Out.a = 0;
    }
    }
    if( fBoolDraw == true ){
    float4 back;
    back.r = ( bg.r * bg.a * (1.0 - Out.a) + Out.r * Out.a );
    back.g = ( bg.g * bg.a * (1.0 - Out.a) + Out.g * Out.a );
    back.b = ( bg.b * bg.a * (1.0 - Out.a) + Out.b * Out.a );
    back.a = (bg.a* ( 1.0 - Out.a ) + Out.a );
    Out = back;
    }
    if( fBoolBorder == true ){
    float4 join;
    join.r = ( border.r * border.a + Out.r * Out.a * (1.0 - border.a) );
    join.g = ( border.g * border.a + Out.g * Out.a * (1.0 - border.a) );
    join.b = ( border.b * border.a + Out.b * Out.a * (1.0 - border.a) );
    join.a = (border.a + Out.a * ( 1.0 - border.a ));
    Out = join;
    }
	
	//if (PM)
	//	Out.rgb *= Out.a;
	
    return Out;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}