
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

sampler2D img ;
sampler2D tImage : register(s1);

uniform float tSpeed,p1,p2,p3,p4 ;
uniform float4 tColor,bColor;

float2 scale(float2 pos, float size, float2 center)
{
 	return float2((pos-center)*size);   
}



 
PS_OUTPUT ps_main( in PS_INPUT In )
{
             
              PS_OUTPUT Out;
             float2 uv = In.Texture;
           //   float4 color = tex2D(img,  uv);
            uv=uv*2.-1.0;
          float2 q = float2((uv.x)/(uv.y/uv.x),uv.y);
 
			
	float3 project =  float3(uv.x,   -0.60, uv.y);
		
	float lookY = p3;
    
	q = project.xy/ (project.z+lookY) + float2(p2, -tSpeed) ; // xx
			  
	 
    float2 z =  float2(scale(q,(abs(1.0)*(p1/2.)),float2(0.,0.)));
    
    float4 tex = tex2D(img,frac(z));
	// Fog factor
	  tex *= smoothstep(-0.2, p4, abs( uv.y + lookY));
     
	  if (uv.y >-lookY  )  Out.Color = float4(tex ); 
	  else 
	  
      Out.Color = lerp(float4(bColor), float4(tColor), tex.a );
               

	return Out  ;
}



technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}