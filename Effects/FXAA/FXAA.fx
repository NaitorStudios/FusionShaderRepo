
//--------------------------------------------------------------------------------------
// Textures and Samplers
//--------------------------------------------------------------------------------------

	sampler2D Tex0 : register(s0) = sampler_state {	
	//MinFilter = Linear;    //type: Anisotropic, GaussianQuad, Linear, LinearMipMapLinear, LinearMipMapNearest, Nearest, NearestMipMapLinear, NearestMipMapNearest, None, Point, PyramidalQuad
	//MagFilter = Linear;    //Anisotropic, GaussianQuad, None, and PyramidalQuad are only supported on Direct3D.
    AddressU = Border;     // mode: Repeat, Wrap, Clamp, ClampToEdge, ClampToBorder, Border, MirroredRepeat, Mirror, MirrorClamp, MirrorClampToEdge, MirrorClampToBorder, MirrorOnce
    AddressV = Border;
};

//--------------------------------------------------------------------------------------
// Input Parameters
//--------------------------------------------------------------------------------------

	float fPixelWidth;
	float fPixelHeight;
	float u_strength;
	
//--------------------------------------------------------------------------------------
// Input / Output structures
//--------------------------------------------------------------------------------------

struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;	
};

/*
struct PS_OUTPUT
{
	float4 Color : COLOR0;
  	float Depth : DEPTH;
};
*/

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------

float4 ps_main( PS_INPUT Input ) : COLOR0

{ 

	float2 u_texel = float2(fPixelWidth,fPixelHeight);
    float reducemul = 1.0 / 8.0;
    float reducemin = 1.0 / 128.0;
    
    float3 basecol = tex2D(Tex0, Input.Texture).rgb;
    float3 baseNW = tex2D(Tex0, Input.Texture - u_texel).rgb;
    float3 baseNE = tex2D(Tex0, Input.Texture + float2(u_texel.x, -u_texel.y)).rgb;
    float3 baseSW = tex2D(Tex0, Input.Texture + float2(-u_texel.x, u_texel.y)).rgb;
    float3 baseSE = tex2D(Tex0, Input.Texture + u_texel).rgb;
    
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
    
    float4 resultA = 0.5 * (tex2D(Tex0, Input.Texture + dir * -0.166667) +
                          tex2D(Tex0, Input.Texture + dir * 0.166667));
    float4 resultB = resultA * 0.5 + 0.25 * (tex2D(Tex0, Input.Texture + dir * -0.5) +
                                           tex2D(Tex0, Input.Texture + dir * 0.5));
    float monoB = dot(resultB.rgb, gray);
    
	
	
	float4 OutColor = tex2D(Tex0, Input.Texture);
	
	
    if(monoB < monomin || monoB > monomax) {
        return  resultA; // * OutColor
    } else {
        return  resultB; // * OutColor
    }
}













//--------------------------------------------------------------------------------------
// Techniques
//--------------------------------------------------------------------------------------

technique tech_main{pass P0{PixelShader = compile ps_2_0 ps_main();}}







