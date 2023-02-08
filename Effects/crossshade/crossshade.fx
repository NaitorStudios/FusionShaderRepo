

sampler2D Tex0;
sampler1D shademap : register(s1);

// ----------------------------------------------------------------------------

// PIXEL SHADER

// ----------------------------------------------------------------------------

float4  PS_Main(float4 color : COLOR0, in float2  input : TEXCOORD0) :	COLOR0
{
 

float4 shadeColor= 0;
float4 maintexture = tex2D(Tex0,input);

shadeColor.r = tex1D(shademap , maintexture.r ).r;
shadeColor.g = tex1D(shademap ,maintexture.g).g;
shadeColor.b = tex1D(shademap ,maintexture.b).b;

color.rgb =  shadeColor;
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