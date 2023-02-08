/*

Colorblindness correction shader with adjustable intensity. Can correct for:
* Protanopia (Greatly reduced reds)
* Deuteranopia (Greatly reduced greens)
* Tritanopia (Greatly reduced blues)

The correction algorithm is taken from http://www.daltonize.org/search/label/Daltonize


 Color correction mode
 0 - Protanopia
 1 - Deutranopia
 2 - Tritanopia
 
*/

sampler2D Tex0;
sampler2D bkd : register(s1);

uniform int mode;

uniform float intensity;

bool BG;

float4 ps_main(float2 In : TEXCOORD ) : COLOR
{
	float4 tex = BG ? tex2D(bkd, In) : tex2D(Tex0, In);
	
	float L = (17.8824 * tex.r) + (43.5161 * tex.g) + (4.11935 * tex.b);
	float M = (3.45565 * tex.r) + (27.1554 * tex.g) + (3.86714 * tex.b);
	float S = (0.0299566 * tex.r) + (0.184309 * tex.g) + (1.46709 * tex.b);

	float l, m, s;
	if (mode == 0) //Protanopia
	{
		l = 0.0 * L + 2.02344 * M + -2.52581 * S;
		m = 0.0 * L + 1.0 * M + 0.0 * S;
		s = 0.0 * L + 0.0 * M + 1.0 * S;
	}
	
	if (mode == 1) //Deuteranopia
	{
		l = 1.0 * L + 0.0 * M + 0.0 * S;
    	m = 0.494207 * L + 0.0 * M + 1.24827 * S;
    	s = 0.0 * L + 0.0 * M + 1.0 * S;
	}
	
	if (mode == 2) //Tritanopia
	{
		l = 1.0 * L + 0.0 * M + 0.0 * S;
    	m = 0.0 * L + 1.0 * M + 0.0 * S;
    	s = -0.395913 * L + 0.801109 * M + 0.0 * S;
	}
	
	float4 error;
	error.r = (0.0809444479 * l) + (-0.130504409 * m) + (0.116721066 * s);
	error.g = (-0.0102485335 * l) + (0.0540193266 * m) + (-0.113614708 * s);
	error.b = (-0.000365296938 * l) + (-0.00412161469 * m) + (0.693511405 * s);
	error.a = 1.0;
	float4 diff = tex - error;
	float4 correction = 0;
	correction.r = 0.0;
	correction.g =  (diff.r * 0.7) + (diff.g * 1.0);
	correction.b =  (diff.r * 0.7) + (diff.b * 1.0);
	correction = tex + lerp(0.0,correction,intensity);
	
	return correction;
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