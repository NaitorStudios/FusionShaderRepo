// Global variables
Texture2D<float4> Texture0 : register(t0);
sampler Tex0 : register(s0);

// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 Uv : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};
 
cbuffer PS_VARIABLES : register(b0)
{

float4 src;
float4 dst;
float treshold;
float intensity;
 
};

 

PS_OUTPUT ps_main( in PS_INPUT In )
{
             
    PS_OUTPUT Out;
     
   
    float4 tx = Texture0.Sample(Tex0, In.Uv);
  
    float4 col = float4(0.0,0.0,0.0,0.0);
	
	if (length(tx.rgb - float3(src.x, src.y, src.z)/255.0) <=treshold)
	{
		col.rgb = float3(dst.x, dst.y, dst.z)/255.0  ;
	}

    else 
	{
		col.rgb = tx.rgb;
	}
	
   
    Out.Color = lerp(tx,col, intensity);
	
	return Out;
}

 