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
Texture2D<float4> img : register(t1);
sampler imgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0)
{
	float offsetX;
	float offsetY;
	float sizeX;
	float sizeY;
	float alpha;
	bool hidden;
};


float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

// Blend coefficient

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float4 Out;
    float4 overlay = Demultiply(img.Sample(imgSampler,In.texCoord));
    Out = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord));
    
    // Backup Alpha
    float keepAlpha = Out.a;

	overlay = Demultiply(img.Sample(imgSampler, float2((In.texCoord.x*sizeX)+offsetX,(In.texCoord.y*sizeY)+offsetY)));

    float4 join;
    
	if (alpha == 2) {
		float4 B = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord));
		float keepAlphaOverlay = overlay.a;
		overlay = B<0.5?(2.0*B*overlay):(1.0-2.0*(1.0-B)*(1.0-overlay));
		overlay.a = keepAlphaOverlay;
	}
    
    join.r = ( overlay.r * overlay.a + Out.r * Out.a * (1.0 - overlay.a) );
    join.g = ( overlay.g * overlay.a + Out.g * Out.a * (1.0 - overlay.a) );
    join.b = ( overlay.b * overlay.a + Out.b * Out.a * (1.0 - overlay.a) );
    join.a = (overlay.a + Out.a * ( 1.0 - overlay.a ));
    
    // texture opacity
    if (alpha < 1) {
		join.r = Out.r * (1-alpha) + join.r * alpha;
		join.g = Out.g * (1-alpha) + join.g * alpha;
		join.b = Out.b * (1-alpha) + join.b * alpha;
	}
	
    Out = join;
    
    // Restore Alpha
    if (hidden) {
		Out = overlay;
		Out.a = keepAlpha - (1-overlay.a);
    }
	else {
		Out.a = keepAlpha;
	}
	Out *= In.Tint;
    return Out;
}


float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    float4 Out;
    float4 overlay = Demultiply(img.Sample(imgSampler,In.texCoord));
    Out = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord));
    
    // Backup Alpha
    float keepAlpha = Out.a;

	overlay = Demultiply(img.Sample(imgSampler, float2((In.texCoord.x*sizeX)+offsetX,(In.texCoord.y*sizeY)+offsetY)));

    float4 join;
    
	if (alpha == 2) {
		float4 B = Demultiply(Tex0.Sample(Tex0Sampler,In.texCoord));
		float keepAlphaOverlay = overlay.a;
		overlay = B<0.5?(2.0*B*overlay):(1.0-2.0*(1.0-B)*(1.0-overlay));
		overlay.a = keepAlphaOverlay;
	}
    
    join.r = ( overlay.r * overlay.a + Out.r * Out.a * (1.0 - overlay.a) );
    join.g = ( overlay.g * overlay.a + Out.g * Out.a * (1.0 - overlay.a) );
    join.b = ( overlay.b * overlay.a + Out.b * Out.a * (1.0 - overlay.a) );
    join.a = (overlay.a + Out.a * ( 1.0 - overlay.a ));
    
    // texture opacity
    if (alpha < 1) {
		join.r = Out.r * (1-alpha) + join.r * alpha;
		join.g = Out.g * (1-alpha) + join.g * alpha;
		join.b = Out.b * (1-alpha) + join.b * alpha;
	}
	
    Out = join;
    
    // Restore Alpha
    if (hidden) {
		Out = overlay;
		Out.a = keepAlpha - (1-overlay.a);
    }
	else {
		Out.a = keepAlpha;
	}
	Out.rgb *= Out.a;
	Out *= In.Tint;
    return Out;
}