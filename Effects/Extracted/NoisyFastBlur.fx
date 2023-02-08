sampler2D img : register(s0);
float strength;

//Ported from this: https://www.shadertoy.com/view/4dKBDR

float2 rand( float2  p ) { p = float2( dot(p,float2(127.1,311.7)), dot(p,float2(269.5,183.3)) ); return frac(sin(p)*43758.5453); }

float4 ps_main(float2 texCoord : TEXCOORD0) : COLOR0
{ 
    float2 uv = texCoord;
    
    return tex2D( img, uv + strength*(rand(uv)-0.5));
}


// Effect technique
technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader	= NULL;
		PixelShader		= compile ps_2_0 ps_main();
	}	
}