
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
float fCoeff;
float fAngle;

PS_OUTPUT ps_main( in PS_INPUT In )
{
  PS_OUTPUT Out;
  PS_OUTPUT OutA;
  PS_OUTPUT OutB;
  PS_OUTPUT OutC;
  PS_OUTPUT OutD;
	fAngle = fAngle*0.0174532925f;
	OutA.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff,In.Texture.y+sin(fAngle)*fCoeff));
	OutB.Color = tex2D(Tex0, float2(In.Texture.x-cos(fAngle)*fCoeff,In.Texture.y-sin(fAngle)*fCoeff));
	OutC.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.66,In.Texture.y+sin(fAngle)*fCoeff*0.5));
	OutD.Color = tex2D(Tex0, float2(In.Texture.x-cos(fAngle)*fCoeff*0.66,In.Texture.y-sin(fAngle)*fCoeff*0.5));
	Out.Color = tex2D(Tex0, In.Texture.xy);
	Out.Color = (Out.Color+OutA.Color+OutB.Color+OutC.Color+OutD.Color)/5;
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