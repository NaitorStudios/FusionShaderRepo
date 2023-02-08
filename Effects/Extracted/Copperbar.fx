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
float rez;
float freq;
//float cn=0.01;
 
float4 ps_main(in float2 uv : TEXCOORD0 ) : COLOR0
{
             
              PS_OUTPUT Out;
           //   float4 color = tex2D(img,  uv+0.5);
 
                uv  = floor(uv *rez)/rez;
	 
	  float cl=0.0;
	
                cl = abs(sin(freq*(uv.y) +tt));
               //  cn +=0.0001;
               Out.Color = float4(cl*clr.r,cl*clr.g,cl*clr.b,1.0);

	return Out.Color;
}
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}