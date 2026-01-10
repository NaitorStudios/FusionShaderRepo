
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
  PS_OUTPUT OutE;
  PS_OUTPUT OutF;
  PS_OUTPUT OutG;
  PS_OUTPUT OutH;
  PS_OUTPUT OutI;
  PS_OUTPUT OutJ;
	fAngle = fAngle*0.0174532925f;
	OutA.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff,In.Texture.y+sin(fAngle)*fCoeff));
	OutB.Color = tex2D(Tex0, float2(In.Texture.x-cos(fAngle)*fCoeff,In.Texture.y-sin(fAngle)*fCoeff));
	OutC.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.8,In.Texture.y+sin(fAngle)*fCoeff*0.8));
	OutD.Color = tex2D(Tex0, float2(In.Texture.x-cos(fAngle)*fCoeff*0.8,In.Texture.y-sin(fAngle)*fCoeff*0.8));
	OutE.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.6,In.Texture.y+sin(fAngle)*fCoeff*0.6));
	OutF.Color = tex2D(Tex0, float2(In.Texture.x-cos(fAngle)*fCoeff*0.6,In.Texture.y-sin(fAngle)*fCoeff*0.6));
	OutG.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.4,In.Texture.y+sin(fAngle)*fCoeff*0.4));
	OutH.Color = tex2D(Tex0, float2(In.Texture.x-cos(fAngle)*fCoeff*0.4,In.Texture.y-sin(fAngle)*fCoeff*0.4));
	OutI.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.2,In.Texture.y+sin(fAngle)*fCoeff*0.2));
	OutJ.Color = tex2D(Tex0, float2(In.Texture.x-cos(fAngle)*fCoeff*0.2,In.Texture.y-sin(fAngle)*fCoeff*0.2));
	Out.Color = tex2D(Tex0, In.Texture.xy);
	Out.Color = (Out.Color+OutA.Color+OutB.Color+OutC.Color+OutD.Color+OutE.Color+OutF.Color+OutG.Color+OutH.Color+OutI.Color+OutJ.Color)/11;
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