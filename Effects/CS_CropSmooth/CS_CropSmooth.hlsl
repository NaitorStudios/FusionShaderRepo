struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Sampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
    float fL;
    float fR;
    float fT;
    float fB;
    float fLSmooth;
    float fRSmooth;
    float fTSmooth;
    float fBSmooth;
    float fA;
};

cbuffer PS_PIXELSIZE : register(b1)
{
    float fPixelWidth;
    float fPixelHeight;
};

float smoothStepEdge(float edge, float smoothness, float coord, float pixelSize)
{
    return smoothstep(edge - smoothness * pixelSize, edge + smoothness * pixelSize, coord);
}

float4 effect(PS_INPUT In, bool PM ) : SV_TARGET
{
    float4 color = Tex0.Sample(Sampler0, In.texCoord) * In.Tint;

    float alphaLeft = smoothStepEdge(fL, fLSmooth, In.texCoord.x, fPixelWidth);
    float alphaRight = smoothStepEdge(1.0f - fR, fRSmooth, 1.0f - In.texCoord.x, fPixelWidth);
    float alphaTop = smoothStepEdge(fT, fTSmooth, In.texCoord.y, fPixelHeight);
    float alphaBottom = smoothStepEdge(1.0f - fB, fBSmooth, 1.0f - In.texCoord.y, fPixelHeight);

    float alpha = min(min(alphaLeft, alphaRight), min(alphaTop, alphaBottom));

    color.a *= alpha * fA;

	if (PM)
		color.rgb *= color.a;
		
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET {
	return effect(In, false);
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET {
	return effect(In, true);
}
