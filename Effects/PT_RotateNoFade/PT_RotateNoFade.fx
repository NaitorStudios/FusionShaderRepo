
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

float fAngle, Temp, Tcos, Tsin;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	In.Texture.x = In.Texture.x-0.5;
	In.Texture.y = In.Texture.y-0.5;
	fAngle =  radians(fAngle);
	Temp = In.Texture.x *cos(fAngle) - In.Texture.y * sin(fAngle) + 0.5;
	In.Texture.y = In.Texture.y * cos(fAngle) + In.Texture.x * sin(fAngle) + 0.5;
	In.Texture.x = Temp;
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