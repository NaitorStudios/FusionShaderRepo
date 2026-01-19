 
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};


// Global variables
sampler2D Tex0 : register(s0);
sampler2D mask;
// add this for antialiasing on the line above:   = sampler_state { MinFilter = Linear; MagFilter = Linear; };

int useTexture, invert;
float cutoff, smooth_size, fade;
float4 color;


float4 ps_main(float2 texCoord : TEXCOORD) : COLOR
{
	float colors;
	if (cutoff < 0.0)
	{
		colors = 1.0 - tex2D(mask, texCoord).r;
		cutoff = cutoff * -1.0;
	} else {
		colors = tex2D(mask, texCoord).r; 
	}
	float alpha = smoothstep(cutoff, cutoff + smooth_size, colors * (1.0 - smooth_size) + smooth_size);
	float4 result;
	if (useTexture == 1) 
	{
		result = float4(tex2D(Tex0, texCoord).rgb, clamp(tex2D(Tex0, texCoord).a, 0, alpha));
		
	} else 
	{
		result = float4(color.rgb, alpha);
	}
	
	return result + (fade * color); 
	
	float2 direction = float2(0,0);
	//if(distort == 1) 
	//{
	//	direction = normalize(float2((tex2D(mask, texCoord).r - 0.5) * 2, (tex2D(mask, texCoord).g - 0.5) * 2));
	//	result = tex2D(Tex0, texCoord * direction);
	//	
	//}
	//return result;

}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_a ps_main();
    }  
}