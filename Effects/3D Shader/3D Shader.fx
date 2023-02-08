
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
sampler2D Tex0;

float h1;
float h2;
float c1;
float c2;
float t1;
float t2;
float l1;
float l2;

PS_OUTPUT ps_main( in PS_INPUT In )
{
	PS_OUTPUT Out;
	Out.Color = float4(1,0,0,1);
	
	float ch = (h1 + (h2 - h1) * In.Texture.x) / 2;
	float cc = c1 + (c2 - c1) * In.Texture.x;
	float cl = l1 + (l2 - l1) * In.Texture.x;
	
	if(In.Texture.y < cc - ch || In.Texture.y > cc + ch) //<<<<<<<<<<<< = ps_2_0
	{
		Out.Color = float4(0,0,0,0);
	}
	else
	{
		float cy = (In.Texture.y - cc + ch) / (ch*2);
		float cx = In.Texture.x * (t2 - t1) + t1;
		Out.Color = tex2D(Tex0, float2(cx,cy));
		Out.Color *= float4(cl,cl,cl,1);
	}
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