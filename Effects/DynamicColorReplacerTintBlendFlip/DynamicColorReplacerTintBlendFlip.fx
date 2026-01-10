sampler2D img = sampler_state
{
	MinFilter = Point;
	MagFilter = Point;
};
sampler2D bkd : register(s1);

#define COLORS 8

float4 from[COLORS];
float4 to[COLORS];
float4 tint;
int blend;
bool flipX;
bool flipY;

#define THRESHOLD (0.33/255)

bool unequal(inout float4 test, in float3 from, in float3 to)
{
	if (distance(test.rgb, from) < THRESHOLD) {
		test.rgb = to;
		return false;
	}
	else
		return true;
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	// Flip texture coordinates without conditionals
	float2 flip = float2((float)flipX, (float)flipY);
	float2 coord = lerp(In, 1.0 - In, flip);

	// Sample textures
	float4 color = tex2D(img, coord);
	float4 background = tex2D(bkd, In);

	// Replace colors
	for (int i = 0; i < COLORS; i++)
		unequal(color, from[i].rgb, to[i].rgb);

	// Apply tint
	color.rgb *= tint.rgb;

	// Blend modes
	if (blend == 1)
		color.rgb = saturate(color.rgb + background.rgb);
	else if (blend == 2)
		color.rgb = max(0, background.rgb - color.rgb);

	return color;
}


technique tech_main {
	pass { PixelShader = compile ps_2_b ps_main(); }
}
