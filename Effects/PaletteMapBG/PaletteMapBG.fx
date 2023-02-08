sampler2D bkg : register(s1);
sampler2D palette : register(s2);

int Cols, Rows; //, Index, X, Y;
const float EPSILON = 1e-10;


float3 RGBtoHSL(in float3 rgb)
{
    // RGB [0..1] to Hue-Chroma-Value [0..1]
    // Based on work by Sam Hocevar and Emil Persson
    float4 p = (rgb.g < rgb.b) ? float4(rgb.bg, -1., 2. / 3.) : float4(rgb.gb, 0., -1. / 3.);
    float4 q = (rgb.r < p.x) ? float4(p.xyw, rgb.r) : float4(rgb.r, p.yzx);
    float c = q.x - min(q.w, q.y);
    float h = abs((q.w - q.y) / (6. * c + EPSILON) + q.z);
    // RGB [0..1] to Hue-Saturation-Lightness [0..1]
    float3 hcv = float3(h, c, q.x);

    float z = hcv.z - hcv.y * 0.5;
    float s = hcv.y / (1. - abs(z * 2. - 1.) + EPSILON);
    return float3(hcv.x, s, z);
}

float OX, OY;
float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(bkg, In);
	float3 hsl = RGBtoHSL(color.rgb);

	// Coordinate of palette entry in the palette
	float2 coord;

	// Calculate position of the spectrum in the palete (identified by saturation)
	float i = hsl.z * Cols * Rows;
	coord.x = floor(fmod(i, Cols)) / Cols;
	coord.y = floor(i / Cols) / Rows;

	// Add X offset for hue
	coord.x += 0.9999 * hsl.x / Cols;
	coord.y += 0.9999 * hsl.y / Rows;

	coord.x += OX;
	coord.y += OY;

	// Load palette color
	color.rgb = tex2D(palette, coord);
	return color;
}

technique tech_main { pass P0 { PixelShader = compile ps_2_0 ps_main(); }}