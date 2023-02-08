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
float4 src;
float4 dst;
float treshold;
float intensity;

  
 
 

float4 ps_main(in float2 uv : TEXCOORD0, in PS_INPUT In) : COLOR0
{
             
              PS_OUTPUT Out;
            float4 tx  = tex2D(img,  uv);
	        float4 col = float4(0.0,0.0,0.0,0.0);
 

            if (length(tx.rgb - float3(src.x, src.y, src.z)) <=treshold)
	{
		col.rgb = float3(dst.x, dst.y, dst.z)  ;
	}

    else 
	{
		col.rgb = tx.rgb;
	}
	
    col.a = tx.a;
    //Out.Color = lerp(tx,col, intensity);
    
    return lerp(tx,col, intensity);
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}