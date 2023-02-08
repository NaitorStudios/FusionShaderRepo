//For greyscale

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

// Global variables
sampler2D Tex0;


float progress;
float angle;
float feather;

const float2 center = 0.5;

float4 ps_main( in PS_INPUT In ) : COLOR0
{
	float4 color = tex2D(Tex0 , In.texCoord);
	float rAngle = radians(angle-90);
	float2 dir = float2(cos(rAngle), sin(rAngle));
	dir = normalize(dir);
	dir /= abs(dir.x)+abs(dir.y);
	float d = dir.x * center.x + dir.y * center.y;
	float m =
		(1.0-step(progress, 0.0)) * // there is something wrong with our formula that makes m not equals 0.0 with progress is 0.0
		(1.0 - smoothstep(-feather, 0.0, dir.x * In.texCoord.x + dir.y * In.texCoord.y - (d-0.5+progress*(1.+feather))));
	float alpha = lerp(color.a, 0.0, m);
	color.a = alpha;
	return color;

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
