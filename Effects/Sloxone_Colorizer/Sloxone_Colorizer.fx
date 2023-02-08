// Gigatron for Sloxone ... MMF2 fx DX9 attempt 

// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 texCoord    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

sampler2D img;
 
float factor,red,green,blue;
 
 
float4 ps_main( in PS_INPUT In ) : COLOR0
{
	float4 Out;
	float4 spr = tex2D(img, In.texCoord);
	
	float4 col = float4(red, green, blue, 1.0);
	spr.rgb    = 1.0 * spr.rgb;
	col.a      = factor;
	float4 f   = lerp(spr, col, col.a);

	if((spr.r>0.0) || (spr.g>0.0) || (spr.b>0.0))
		Out = f;
	else
		Out = 0.0;
		
	if (spr.a == 0.0)
		Out.a = 0.0;
	
	return Out;
}
technique tech_main { pass P0 { PixelShader  = compile ps_2_0 ps_main(); }}