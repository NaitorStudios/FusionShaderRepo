// Gigatron runner 
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};
float2  magnify(float2  p, float x, float y) 
{
	if (y < 0.)
		return p * (1. + x);
	else
		return p * (1. - x);
}

// random function return=2 vect x,y comp !!
float rand(float2 co)
{
    return frac(sin(dot(co.xy ,float2 (12.9898,78.233))) * 43758.5453);
}


// Global variables
#define PI 3.14159265359
sampler2D img;
uniform float fSpeed;
uniform float4 fCol;
uniform float fMfactor;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    float2 uv = In.Texture;	// my uv ;)
   
              float2 position=2.*uv-1.0;
	position.y =-position.y;
	
	float2 pos;
	pos.x = position.x / abs(position.y);
	pos.y = tan(lerp(PI/2., PI/4., abs(position.y)));
	
	pos = magnify(pos, fMfactor, position.y);
	pos.x -= 1.0 * fSpeed;
	float tile = rand(round(pos*6.)); 
	tile = max(tile*2.0, 0.00);
	 
 
 
             Out.Color =   (0.7+0.1* tile)* float4(fCol)  * step(position.y, 0.0); ;


 
 

           return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}