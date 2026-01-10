sampler2D img : register(s0) = sampler_state {
MinFilter = None;
MagFilter = None;
};

/*
Squish Sprite Shader by Garmelon (https://github.com/Garmelon)
Documented by Mateus-Carmo31
*/

uniform float x_factor = 1.0;
uniform float bulge;// : hint_range(-1,1);

void vertex(in float2 UV : TEXCOORD0)
{
	// Stretches the sprite along the x axis by the x_factor.
	// This essentially increases the bounds in which the sprite can be drawn,
	// allowing the sprite to bulge outwards appropriately.
	UV.x *= x_factor;
}

// Describes how the sprite bulges. Right now, it's a simple half-circle function.
// Changing it modifies how the bulges will look like.
// Must be a function in which the x will be between 0 and 1 for y between -1 and 1.
float bulge_function(float y)
{
	return sqrt(1.0 - y*y);
}

float4 ps_main(in float2 UV : TEXCOORD0) : COLOR0
{
	float4 COLOR;
	// Remaps the UV (normally from 0.0 to 1.0) to go from -1.0 to 1.0
	float2 uv = UV * 2.0 - 1.0;
	
	// Counteracts the vertex stretch by increasing the uv by the same factor
	// (Since textures are mapped from 0 to 1, multiplying the UV will make
	// it go from 0 to something else, and the texture will remain between 0 and 1.
	// this results in it becoming smaller)
	uv.x *= x_factor;
	
	/* The main meat of the shader.
	Calculates a displacement using the bulge factor and the function,
	then divides the x by it. 
	
	If the displacement is larger than 1, the uv.x will become smaller, and, in
	the process, when the uv is used for sampling, a pixel more towards the
	middle of the texture will be sampled instead. This causes far UV values to
	now be able to have a correspondent pixel in the [-1, 1] range (that will
	be unmapped back to [0,1] later), "pulling out" the OG texture.
	 
	An inverted process occurs with displacement smaller than 1:
	uv.x becomes larger -> pixels move away from middle -> 
	inner values sample from farther away -> texture gets "pulled in"
	
	This also has the bonus of causing certain pixels to sample values  1,
	which will be caught by the if statement below and be rendered transparent.
	
	Remember as well that the x factor causes the UV to go from -2 to 2 on the x
	axis.
	*/
	float displacement = 1.0 + bulge * bulge_function(uv.y);
	uv.x /= displacement;
	
	// Undoes the remapping we did at the beginning
	uv = (uv + 1.0) / 2.0;
	
	// Checks for uv values outside the texture, and draws them as transparent,
	// allowing the "indentation" effect when bulge = 0.0 && uv.x <= 1.0)
	if((uv.x >= 0.0) && (uv.x <= 1.0))	
	{
		COLOR = tex2D(img, uv);
	}
	else
	{
		COLOR = 0.0;
	}
	return COLOR;
}

technique tech_main { pass P0 { PixelShader  = compile ps_2_a ps_main(); }}