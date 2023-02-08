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

 
float tt;
float4 clr;
float4 clg;
float4 clb;
float freq;
//float cn=0.01;
 
float4 ps_main(in float2 uv : TEXCOORD0 ) : COLOR0
{
             
            PS_OUTPUT Out;
            float3 color = tex2D(img,  uv).rgb;
            color.r =  color.r+clr.r;
            color.g = color.g+clr.g;
            color.b = color.b+clr.b;
	  
          //  Out.Color = float4(0.5+.5*sin(10.0 *  (length(color.rgb) + tt * 0.1)),0.5+.5*sin(10.0  * (length(color.rgb) + tt * 0.2)),0.5+.5*sin(10.0  * (length(color.rgb) + tt * 0.3)),1.0);
           
            Out.Color  = 0.5+.5*sin(10.0 *(length(color.rgb) + tt * 0.1));
           

          Out.Color.a = 1.0;
            return Out.Color;
}
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}