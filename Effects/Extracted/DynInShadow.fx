
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
float fOp;

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
	OutA.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff,In.Texture.y-sin(fAngle)*fCoeff));
	OutB.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.9,In.Texture.y-sin(fAngle)*fCoeff*0.9));
	OutC.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.8,In.Texture.y-sin(fAngle)*fCoeff*0.8));
	OutD.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.7,In.Texture.y-sin(fAngle)*fCoeff*0.7));
	OutE.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.6,In.Texture.y-sin(fAngle)*fCoeff*0.6));
	OutF.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.5,In.Texture.y-sin(fAngle)*fCoeff*0.5));
	OutG.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.4,In.Texture.y-sin(fAngle)*fCoeff*0.4));
	OutH.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.3,In.Texture.y-sin(fAngle)*fCoeff*0.3));
	OutI.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.2,In.Texture.y-sin(fAngle)*fCoeff*0.2));
	OutJ.Color = tex2D(Tex0, float2(In.Texture.x+cos(fAngle)*fCoeff*0.1,In.Texture.y-sin(fAngle)*fCoeff*0.1));
	Out.Color = tex2D(Tex0, In.Texture.xy);
	Out.Color.r = tex2D(Tex0, In.Texture.xy).r-(Out.Color.r+OutA.Color.r+OutB.Color.r+OutC.Color.r+OutD.Color.r+OutE.Color.r+OutF.Color.r+OutG.Color.r+OutH.Color.r+OutI.Color.r+OutJ.Color.r)*fOp;
	Out.Color.g = tex2D(Tex0, In.Texture.xy).g-(Out.Color.g+OutA.Color.g+OutB.Color.g+OutC.Color.g+OutD.Color.g+OutE.Color.g+OutF.Color.g+OutG.Color.g+OutH.Color.g+OutI.Color.g+OutJ.Color.g)*fOp;
	Out.Color.b = tex2D(Tex0, In.Texture.xy).b-(Out.Color.b+OutA.Color.b+OutB.Color.b+OutC.Color.b+OutD.Color.b+OutE.Color.b+OutF.Color.b+OutG.Color.b+OutH.Color.b+OutI.Color.b+OutJ.Color.b)*fOp;
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