
// Pixel shader input structure
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);


// original wind shader from https://github.com/Maujoe/godot-simple-wind-shader-2d/tree/master/assets/maujoe.simple_wind_shader_2d
// original script modified by HungryProton so that the assets are moving differently : https://pastebin.com/VL3AfV8D
// Then ported and modified by NaitorStudios. Main addition is the distortion that wasn't originally implemented.


cbuffer PS_VARIABLES : register(b0)
{

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

};

float getWind(float2 uv, float time)
{
	float diff = pow(maxStrength - minStrength, 2.0);
	float strength = clamp(minStrength + diff + sin(time / interval) * diff, minStrength, maxStrength) * strengthScale;
	float wind = (sin(time) + cos(time / interval * detail)) * strength * max(0.0, (1.0-uv.y) - heightOffset);
    
	return wind; 
}

float4 ps_main( in PS_INPUT UV ) : SV_TARGET
{
	float time = TIME * speed + offset;
	UV.texCoord.x += getWind(UV.texCoord, time);
	UV.texCoord.x -= ((UV.texCoord.y-0.9) * distortion)*max(sin(time * detail  + (10*cos(UV.texCoord.y)))-distHeightOffset,0.0);
	
	return img.Sample(imgSampler, UV.texCoord.xy) * UV.Tint;
}

