sampler2D img : register(s0) = sampler_state {
MinFilter = Linear;
MagFilter = Linear;
};

// original wind shader from https://github.com/Maujoe/godot-simple-wind-shader-2d/tree/master/assets/maujoe.simple_wind_shader_2d
// original script modified by HungryProton so that the assets are moving differently : https://pastebin.com/VL3AfV8D
//Then ported and modified by NaitorStudios. Main addition is the distortion that wasn't originally implemented.

float TIME;
uniform float speed;
uniform float minStrength;
uniform float maxStrength;
uniform float strengthScale;
uniform float interval;
uniform float detail;
uniform float distortion;
uniform float heightOffset;
uniform float distHeightOffset;
uniform float offset; 

float getWind(float2 vertex, float2 uv, float time)
{
	float diff = pow(maxStrength - minStrength, 2.0);
	float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
	float wind = (sin(time) + cos(time / interval * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
    
	return wind; 
}

float4 ps_main(in float2 UV : TEXCOORD0) : COLOR0
{
	float time = TIME * speed + offset;
	UV.x += getWind(UV.xy, UV, time);
	UV.x -= ((UV.y-0.9) * distortion)*max(sin(time * detail  + (10*cos(UV.y)))-distHeightOffset,0.0);
	
	return tex2D(img, UV.xy);
}

// Effect technique
technique tech_main
{
	pass P0
	{
		// shaders
		VertexShader	= NULL;
		PixelShader		= compile ps_2_0 ps_main();
	}	
}