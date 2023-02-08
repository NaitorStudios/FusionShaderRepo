struct PS_INPUT
{
	float4 Position   : POSITION;
	float2 Texture    : TEXCOORD0;

};

struct PS_OUTPUT
{
	float4 Color   : COLOR0;

};

//Variables
sampler2D img; //base texture
sampler2D fPalette; //palette texture
float fIndex;
float fHeight;

PS_OUTPUT ps_main( in PS_INPUT In )
{
	PS_OUTPUT Out;

	Out.Color = tex2D(img,In.Texture.xy);
	Out.Color.rgb = Out.Color.rgb;
	
	//Calculate palette index v coordinate
	float vCoord = (fIndex / fHeight) - 0.03;
	
	float2 coord;
	coord.x = Out.Color.b;
	coord.y = vCoord;

	Out.Color.rgb = tex2D(fPalette, coord);

	return Out;

}

technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader = NULL;
		PixelShader  = compile ps_2_0 ps_main();

	}  

}