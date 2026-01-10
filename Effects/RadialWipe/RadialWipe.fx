//For greyscale

// Pixel shader input structure
struct PS_INPUT
{
    float4 Position : POSITION;
    float2 texCoord : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color : COLOR0;
};

// Global variables
sampler2D Tex0;

float progress;
float feather;

const float2 center = float2(0.5, 0.5);

float4 ps_main(in PS_INPUT In) : COLOR0
{
    float4 color = tex2D(Tex0, In.texCoord);
    float2 dir = normalize(center - In.texCoord);
    float d = dot(dir, center);
    float m =
        (1.0 - step(progress, 0.0)) *
        (1.0 - smoothstep(-feather, 0.0, dot(dir, In.texCoord) - (d - 0.5 + progress * (1.0 + feather))));
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
        PixelShader = compile ps_2_0 ps_main();
    }
}
