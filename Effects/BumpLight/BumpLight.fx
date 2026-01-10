
float light_x;
float light_y;
float light_z;


float3 LightDir={1,1,1};
float3 LightColor = {0.5,1,1};
float AmbientColor;

sampler2D Tex0;
sampler2D bumpmap : register(s1);

// ----------------------------------------------------------------------------

// PIXEL SHADER

// ----------------------------------------------------------------------------

float4  PS_Main(float4 color : COLOR0, in float2  input : TEXCOORD0) :	COLOR0
{
 

LightDir= normalize(float3(light_x,light_y,1));

 float4 specColor=float4(0.1,0.1,0.1,0.1);
float3 amb = { AmbientColor, AmbientColor, AmbientColor};


float4 maintexture = tex2D(Tex0,input);
float4 normalmap = 2*tex2D(bumpmap,input)-1.0;
float lightamt = max(dot(normalmap.xyz,LightDir),0.0);

color.rgb *= maintexture*( amb + ( lightamt * LightColor));

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
       AlphaBlendEnable = true;
        SrcBlend = SrcAlpha;
        DestBlend = InvSrcAlpha;
       PixelShader =  compile  ps_2_0   PS_Main();
 }
  
}