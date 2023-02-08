
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
sampler2D Tex0;
float fCoeffX;
float fCoeffY;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	Out.Color = tex2D(Tex0, In.Texture);
	
	float4 c2 = tex2D(Tex0, In.Texture.xy + float2(0,-fCoeffY));
	float4 c4 = tex2D(Tex0, In.Texture.xy + float2(-fCoeffX,0));
	float4 c5 = tex2D(Tex0, In.Texture.xy + float2(0,0));
	float4 c6 = tex2D(Tex0, In.Texture.xy + float2(fCoeffX,0));
	float4 c8 = tex2D(Tex0, In.Texture.xy + float2(0,fCoeffY));
	
	float4 c0 = (-c2-c4+c5*4-c6-c8);
	if(length(c0) < 1.0) c0 = float4(0,0,0,0);
	else c0 = float4(1,1,1,0);
	
	Out.Color.rgb = c0;
	
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