
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

float fAngle;
float fRadius;
float4 fC;
float fA;

PS_OUTPUT ps_main( in PS_INPUT In )
{
	// Output pixel
	PS_OUTPUT Out;

	fAngle = fAngle*0.0174532925f;
	float dx = cos(fAngle) * fRadius;
	float dy = sin(fAngle) * fRadius;

	float2 dxyr;
	dxyr.x = dx - dy;
	dxyr.y = dx + dy;

	float4 Shade;

	Out.Color = tex2D(Tex0, In.Texture.xy);
	Shade = tex2D(Tex0,float2(In.Texture.x-dxyr.x,In.Texture.y-dxyr.y));
	Shade.a *= fA;
	Shade.rgb = fC;
	if(Out.Color.a < 1) {
		Out.Color.r += (Shade.r-Out.Color.r)*(1-Out.Color.a);
		Out.Color.g += (Shade.g-Out.Color.g)*(1-Out.Color.a);
		Out.Color.b += (Shade.b-Out.Color.b)*(1-Out.Color.a);
		Out.Color.a += (Shade.a-Out.Color.a)*(1-Out.Color.a);
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