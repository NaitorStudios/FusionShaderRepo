// Global variables	
sampler2D tex : register(s0);
sampler2D bkd : register(s1);

static const float4 colors[6] = {
        float4(0.0, 0.0, 0.0, 0.0),
        float4(0.055, 0.086, 0.102, 0.078555),
        float4(0.255, 0.357, 0.322, 0.322512),
        float4(0.565, 0.675, 0.518, 0.624212),
        float4(0.886, 0.933, 0.855, 0.910055),
        float4(1.0, 1.0, 1.0, 1.0)
    };

float4 ps_main(float2 texCoord : TEXCOORD) : COLOR
{
	float4 texColor = tex2D(tex, texCoord);
	float4 bkdColor = tex2D(bkd, texCoord);
	
	// Convert color to grayscale to compare brightness
	float brightness = dot(bkdColor.rgb, float3(0.299, 0.587, 0.114));
	
	// Find next higher color
	int closestIndex = 5;
	float closest = 99.0;

    for (int i = 1; i < 6; i++) {
		float diff = colors[i].a - brightness;
		if (diff > 0.01 && diff < closest) {
			closest = diff;
			closestIndex = i;
		}
	}
    float4 nextColor = colors[closestIndex];
	nextColor.a = 1.0;
	return nextColor * texColor;
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