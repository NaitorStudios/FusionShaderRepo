
struct PS_INPUT
{
    float4 Tint     : COLOR0;
    float2 texCoord : TEXCOORD0;
};


Texture2D<float4> Img : register(t0);
SamplerState ImgSampler : register(s0);

cbuffer PS_VARIABLES:register(b0)
{
    float h1;
    float h2;
    float c1;
    float c2;
    float l1;
    float l2;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    // Get the Y coordinates of the four corners.
    float Ay = c1 - (h1 / 2);
    float By = c2 - (h2 / 2);
    float Cy = c2 + (h2 / 2);
    float Dy = c1 + (h1 / 2);

    // Find the intersection of the two diagonals.
    float Ix = (Dy - Ay) / ((Cy - Ay) - (By - Dy));
    float Iy = (Cy - Ay) * Ix + Ay;

    // Scale the Y coordinate based on the X coordinate.
    float ch = (h1 + (h2 - h1) * In.texCoord.x) / 2;
    float cc = c1 + (c2 - c1) * In.texCoord.x;
    float ty = (In.texCoord.y - cc + ch) / (ch * 2);

    // Use cross-ratio metrology to correct the X coordinate.
    float cr = (In.texCoord.x / (Ix - In.texCoord.x)) / (1 / (Ix - 1));
    float tx = cr / (2 * cr - 1);

    // Sample the texture.
    float4 col = Demultiply(Img.Sample(ImgSampler, float2(tx, ty)));

    // Lighting
    float light = l1 + (l2 - l1) * tx;
    col.rgb *= light;
	
	if (PM)
		col.rgb *= col.a;
		
	return col * In.Tint;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}