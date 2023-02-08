// Gigatron for Sloxone ... MMF2 fx DX9 attempt 
sampler2D img ;
sampler2D simg : register(s1);

struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

 
float sxsize,sysize,snum,sx,sy;
 
 
float4 ps_main(in float2 uv : TEXCOORD0 ) : COLOR0
{
             
     PS_OUTPUT Out;
     
    
   float2 dem = float2(sx, sy); 
   float2  pixelSize = float2 (uv.x,uv.y) / dem;

   //  uv.x = uv.x+snum;
    // sprite region  
    float2 uv0 = float2(sx, sy);
    float2 uv1 = float2(sxsize, sysize);
     
    uv = uv0 + uv*(uv1 + uv0)-float2(sxsize,0.0)*snum; /// Only x position yet ;;


     float4 sprsrc = tex2D(img,  uv);
     float4 sprdst = tex2D(simg,  uv);



   
     
    Out.Color = sprsrc*sprdst;
 

	return Out.Color;
}
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}