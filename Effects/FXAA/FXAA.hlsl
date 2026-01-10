
//--------------------------------------------------------------------------------------
// Textures and Samplers
//--------------------------------------------------------------------------------------

	Texture2D<float4> Tex0 : register(t0);
	sampler Tex0Sampler : register(s0);

//--------------------------------------------------------------------------------------
// Input Parameters
//--------------------------------------------------------------------------------------

	cbuffer PS_VARIABLES : register(b0)
	{
		float u_strength;
	}
	
	cbuffer PS_PIXELSIZE : register(b1)
	{
		float fPixelWidth;
		float fPixelHeight;
	};
	
//--------------------------------------------------------------------------------------
// Input / Output structures
//--------------------------------------------------------------------------------------

struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

/*
struct PS_OUTPUT
{
	float4 Color : COLOR0;
  	float Depth : DEPTH;
};
*/

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------

float4 ps_main( in PS_INPUT Input ) : SV_TARGET

{ 

	float2 u_texel = float2(fPixelWidth,fPixelHeight);
    float reducemul = 1.0 / 8.0;
    float reducemin = 1.0 / 128.0;
    
    float3 basecol = Tex0.Sample(Tex0Sampler, Input.texCoord).rgb;
    float3 baseNW = Tex0.Sample(Tex0Sampler, Input.texCoord - u_texel).rgb;
    float3 baseNE = Tex0.Sample(Tex0Sampler, Input.texCoord + float2(u_texel.x, -u_texel.y)).rgb;
    float3 baseSW = Tex0.Sample(Tex0Sampler, Input.texCoord + float2(-u_texel.x, u_texel.y)).rgb;
    float3 baseSE = Tex0.Sample(Tex0Sampler, Input.texCoord + u_texel).rgb;
    
    float3 gray = float3(0.299, 0.587, 0.114);
    float monocol = dot(basecol, gray);
    float monoNW = dot(baseNW, gray);
    float monoNE = dot(baseNE, gray);
    float monoSW = dot(baseSW, gray);
    float monoSE = dot(baseSE, gray);
    
    float monomin = min(monocol, min(min(monoNW, monoNE), min(monoSW, monoSE)));
    float monomax = max(monocol, max(max(monoNW, monoNE), max(monoSW, monoSE)));
    
    float2 dir = float2(-((monoNW + monoNE) - (monoSW + monoSE)), ((monoNW + monoSW) - (monoNE + monoSE)));
    float dirreduce = max((monoNW + monoNE + monoSW + monoSE) * reducemul * 0.25, reducemin);
    float dirmin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirreduce);
    dir = min(float2(u_strength,u_strength), max(float2(-u_strength,-u_strength), dir * dirmin)) * u_texel;
    
    float4 resultA = 0.5 * (Tex0.Sample(Tex0Sampler, Input.texCoord + dir * -0.166667) +
                          Tex0.Sample(Tex0Sampler, Input.texCoord + dir * 0.166667));
    float4 resultB = resultA * 0.5 + 0.25 * (Tex0.Sample(Tex0Sampler, Input.texCoord + dir * -0.5) +
                                           Tex0.Sample(Tex0Sampler, Input.texCoord + dir * 0.5));
    float monoB = dot(resultB.rgb, gray);
    
	
	
	float4 OutColor = Tex0.Sample(Tex0Sampler, Input.texCoord);
	
	
    if(monoB < monomin || monoB > monomax) {
        return  resultA; // * OutColor
    } else {
        return  resultB; // * OutColor
    }
}
