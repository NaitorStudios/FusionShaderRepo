Texture2D<float4> tex : register(t0);
sampler texSampler : register(s0);

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

cbuffer PS_VARIABLES : register(b0)
{
    float4 outlineColor;
}

cbuffer PS_PIXELSIZE : register(b1)
{
	float fPixelWidth;
	float fPixelHeight;
};

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.xyz /= color.a;
	return color;
}

float4 ps_main(PS_INPUT In) : SV_TARGET
{
    float4 c = tex.Sample(texSampler, In.texCoord);

    // Treat "fully transparent" with a tiny epsilon to avoid == 0.0 issues
    const float ALPHA_EPS = 1.0 / 255.0;
    float isTransparent = (c.a < ALPHA_EPS) ? 1.0 : 0.0;

    // 4-neighbor alpha max
    float aR = tex.Sample(texSampler, In.texCoord + float2( fPixelWidth, 0)).a;
    float aL = tex.Sample(texSampler, In.texCoord + float2(-fPixelWidth, 0)).a;
    float aU = tex.Sample(texSampler, In.texCoord + float2(0,  fPixelHeight)).a;
    float aD = tex.Sample(texSampler, In.texCoord + float2(0, -fPixelHeight)).a;
    float neighbor = max(max(aR, aL), max(aU, aD));

    // Consider as edge if pixel is fully transparent and neighbors a non-transparent pixel
    float edge = ((neighbor < ALPHA_EPS) ? 0.0 : 1.0) * isTransparent;

    // Apply outline color only on those edge pixels
    float3 rgb = lerp(c.rgb, outlineColor.rgb, edge);
    float  a   = max(c.a, edge);

    return Demultiply(float4(rgb, a)) * In.Tint;
}

float4 ps_main_pm(PS_INPUT In) : SV_TARGET
{
    float4 c = tex.Sample(texSampler, In.texCoord);

    // Treat "fully transparent" with a tiny epsilon to avoid == 0.0 issues
    const float ALPHA_EPS = 1.0 / 255.0;
    float isTransparent = (c.a < ALPHA_EPS) ? 1.0 : 0.0;

    // 4-neighbor alpha max
    float aR = tex.Sample(texSampler, In.texCoord + float2( fPixelWidth, 0)).a;
    float aL = tex.Sample(texSampler, In.texCoord + float2(-fPixelWidth, 0)).a;
    float aU = tex.Sample(texSampler, In.texCoord + float2(0,  fPixelHeight)).a;
    float aD = tex.Sample(texSampler, In.texCoord + float2(0, -fPixelHeight)).a;
    float neighbor = max(max(aR, aL), max(aU, aD));

    // Consider as edge if pixel is fully transparent and neighbors a non-transparent pixel
    float edge = ((neighbor < ALPHA_EPS) ? 0.0 : 1.0) * isTransparent;

    // Apply outline color only on those edge pixels
    float3 rgb = lerp(c.rgb, outlineColor.rgb, edge);
    float  a   = max(c.a, edge);

    return float4(rgb, a) * In.Tint;
}