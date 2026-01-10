
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float4 tColor,bColor;
	float tSpeed,p1,p2,p3,p4 ;
}

float2 scale(float2 pos, float size, float2 center)
{
 	return float2((pos-center)*size);   
}

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
} 
 
PS_OUTPUT ps_main( in PS_INPUT In )
{
	PS_OUTPUT Out;
	float2 uv = In.texCoord;
	//float4 color = img.Sample(imgSampler,  uv);
	uv=uv*2.-1.0;
	float2 q = float2((uv.x)/(uv.y/uv.x),uv.y);

	float3 project =  float3(uv.x,   -0.60, uv.y);
		
	float lookY = p3;
    
	q = project.xy/ (project.z+lookY) + float2(p2, -tSpeed) ; // xx
			  
	 
    float2 z =  float2(scale(q,(abs(1.0)*(p1/2.)),float2(0.,0.)));
    
    float4 tex = Demultiply(img.Sample(imgSampler,frac(z)) * In.Tint);
	// Fog factor
	tex *= smoothstep(-0.2, p4, abs( uv.y + lookY));
	
	if (uv.y >-lookY  )  Out.Color = float4(tex ); 
	else 
	Out.Color = lerp(float4(bColor), float4(tColor), tex.a );
	
	Out.Color *= In.Tint;
	return Out;
}

PS_OUTPUT ps_main_pm( in PS_INPUT In )
{
	PS_OUTPUT Out;
	float2 uv = In.texCoord;
	//float4 color = img.Sample(imgSampler,  uv);
	uv=uv*2.-1.0;
	float2 q = float2((uv.x)/(uv.y/uv.x),uv.y);

	float3 project =  float3(uv.x,   -0.60, uv.y);
		
	float lookY = p3;
    
	q = project.xy/ (project.z+lookY) + float2(p2, -tSpeed) ; // xx
			  
	 
    float2 z =  float2(scale(q,(abs(1.0)*(p1/2.)),float2(0.,0.)));
    
    float4 tex = Demultiply(img.Sample(imgSampler,frac(z)) * In.Tint);
	// Fog factor
	tex *= smoothstep(-0.2, p4, abs( uv.y + lookY));
	
	if (uv.y >-lookY  )  Out.Color = float4(tex ); 
	else 
	Out.Color = lerp(float4(bColor), float4(tColor), tex.a );
	
	Out.Color.rgb *= Out.Color.a;
	return Out;
}
