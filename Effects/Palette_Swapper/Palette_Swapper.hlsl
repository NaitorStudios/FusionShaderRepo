// Pixel shader input structure
struct PS_INPUT
{
    float4 Tint   : POSITION;
    float2 texCoord    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};


Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);
Texture2D<float4> fPalette;
sampler fPaletteSampler;

cbuffer PS_VARIABLES : register(b0)
{
	float fIndex;
	float fHeight;
};

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{

	float4 Sprite = img.Sample(imgSampler,In.texCoord.xy) * In.Tint;
	
	//Calculate palette index v coordinate
	float vCoord = (fIndex / fHeight) - 0.03;
	
	float2 coord;
	coord.x = Sprite.b;
	coord.y = vCoord;

	float4 Out;
	Out.rgb = fPalette.Sample(fPaletteSampler, coord).rgb;
	Out.a = Sprite.a;
	
	return Out;

}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

// This Premultiplied version is necessary since it's working with alpha channels as well.
float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
	// Basically it has to be demultiplied here...
	float4 Sprite = Demultiply(img.Sample(imgSampler,In.texCoord.xy) * In.Tint);
	
	//Calculate palette index v coordinate
	float vCoord = (fIndex / fHeight) - 0.03;
	
	float2 coord;
	coord.x = Sprite.b;
	coord.y = vCoord;

	float4 Out;
	Out.rgb = fPalette.Sample(fPaletteSampler, coord).rgb;
	Out.a = Sprite.a;
	// And multiplied here
	Out.rgb *= Out.a;
	
	return Out;

}

