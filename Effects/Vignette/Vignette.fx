
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

sampler2D Tex0 : register(s0) = sampler_state {
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = Point;
};

sampler2D bkd : register(s1) = sampler_state {
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = Point;
};

bool bg;
float amount;
float4 tint;

float4 ps_main( float2 In : TEXCOORD0 ) : COLOR0
{
    float2 tex = In * 2 - 1;
    float dis = length(tex);
    dis = dis / 1.4142135623730950488016887242097;
    dis = pow(dis, 3);
	float4 output = float4(tint.rgb, 1.0-pow(1 - dis * amount, 2));
	float4 Color = bg ? tex2D(bkd,In) : tex2D(Tex0,In);
	
	// Alpha Overlay
	float new_a = 1-(1-output.a)*(1-Color.a);
	output.rgb = (output.rgb*output.a+Color.rgb*Color.a*(1-output.a))/new_a;
	output.a = Color.a;
	
    return output;
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