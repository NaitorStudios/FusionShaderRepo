

sampler2D Tex0;

float4  PS_Main(float4 color : COLOR0, in float2  input : TEXCOORD0) :	COLOR0
{
 

float4 maintexture = tex2D(Tex0,input);

color.r = (maintexture.r * 0.393) + (maintexture.g * 0.769) + (maintexture.b * 0.189);
color.g = (maintexture.r * 0.349) + (maintexture.g  * 0.686) + (maintexture.b * 0.168);
color.b = (maintexture.r * 0.272) + (maintexture.g * 0.534) + (maintexture.b *  0.131);
color.a = maintexture.a;

  return color;

}




// ----------------------------------------------------------------------------

// TECHNIQUES

// ----------------------------------------------------------------------------



technique tech_main
  
{
 
 pass p0 
 
 { 
       
       PixelShader =  compile  ps_2_0   PS_Main();
 }
  
}