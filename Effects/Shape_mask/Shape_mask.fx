sampler2D Tex0;
sampler2D bkd : register(s1); 
float4 outerColor;

float4  PS_Main(float4 color : COLOR0, in float2  input : TEXCOORD0) :	COLOR0
{
 

float4 maintexture = tex2D(Tex0,input);
float4 backtexture = tex2D(bkd,input);

if(maintexture.r ==1 && maintexture.g ==1 && maintexture.b==1 && maintexture.a==1)
{
color = backtexture;
}
else
{
color = outerColor;
}



  return color;

}



technique tech_main
  
{
 
 pass p0 
 
 { 
       
       PixelShader =  compile ps_2_0   PS_Main();
 }
  
}