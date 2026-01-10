
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
float fCoeff, fAngle, Angle, Dist;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	Dist = distance(In.Texture.xy, float2(0.5,0.5)) * 2;
	if (Dist < 1.0){
		Angle = atan2(In.Texture.y - 0.5, In.Texture.x - 0.5) + pow(1 - Dist,2) * fAngle;
		Dist = (pow(Dist,fCoeff)) / 2;
		In.Texture.x = cos(Angle) * Dist + 0.5;
		In.Texture.y = sin(Angle) * Dist + 0.5;
	}
   	Out.Color = tex2D(Tex0, In.Texture.xy);
	
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
   