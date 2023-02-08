sampler2D img ;
sampler2D bkd : register(s1);
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

float lvl;
  
 
 

float4 ps_main(in float2 uv : TEXCOORD0, in PS_INPUT In) : COLOR0
{
             
              PS_OUTPUT Out;
           //   float4 color = tex2D(img,  uv+0.5);
 

             float2 flck = uv;
  
              flck.x += rand(float2(0,uv.y)*(tt)) * 1.0;
              flck.y += rand(float2(0,uv.x)*(tt)) * 1.0;
    
              float3 c = float3(0.0,0.0,0.0);
    
 

	return float4(c,1.0);
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}