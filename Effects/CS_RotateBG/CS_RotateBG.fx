
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Tex0 : register(s1) = sampler_state {
AddressU = border;
AddressV = border;
BorderColor = float4(1.0,1.0,1.0,0.0);
};

float fAngle;
float fX;
float fY;

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	
	fAngle = fAngle*0.0174532925f;
	
    //In.Texture.x = In.Texture.x + fX*(fWidth-1.0f);
	//In.Texture.y = In.Texture.y + fY*(fHeight-1.0f);
	float Ray = sqrt(pow(In.Texture.x-fX,2)+pow(In.Texture.y-fY,2));
	float Angle;
	if(In.Texture.y-fY>0)
	{
		Angle = acos((In.Texture.x-fX)/Ray);
	}
	else
	{
		Angle = 0-acos((In.Texture.x-fX)/Ray);
	}
		
    In.Texture.x = fX + cos(Angle+fAngle)*Ray;
    In.Texture.y = fY + sin(Angle+fAngle)*Ray;
   	Out.Color = tex2D(Tex0, In.Texture.xy);
	
    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}