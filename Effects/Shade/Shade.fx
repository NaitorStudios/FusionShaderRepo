
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

// Global variables
sampler2D Texture0;

float fX;
float fY;
float4 fC;
float fA;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    PS_OUTPUT Shade;
    Out.Color = tex2D(Texture0,In.Texture);
    Shade.Color = tex2D(Texture0,float2(In.Texture.x-fX,In.Texture.y-fY));
		Shade.Color.a *= fA;
		Shade.Color.rgb = fC;
		if(Out.Color.a < 1) {
			Out.Color.r += (Shade.Color.r-Out.Color.r)*(1-Out.Color.a);
			Out.Color.g += (Shade.Color.g-Out.Color.g)*(1-Out.Color.a);
			Out.Color.b += (Shade.Color.b-Out.Color.b)*(1-Out.Color.a);
			Out.Color.a += (Shade.Color.a-Out.Color.a)*(1-Out.Color.a);
		}
	
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