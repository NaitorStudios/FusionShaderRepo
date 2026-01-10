float fPixelWidth;
float fPixelHeight;
int mask_width;
int mask_height;
int mask_x;
int mask_y;
sampler2D Tex0;
sampler2D masktex : register(s1) = sampler_state {
AddressU = Wrap;
AddressV = Wrap;
};

float4 PS_Main(float4 color : COLOR0, in float2 input : TEXCOORD0) : COLOR0
{
    float4 maintexture = tex2D(Tex0, input);

	// Normalize coordinates to [0,1] within the mask area
	float2 maskUV = float2(
		(input.x / fPixelWidth - mask_x) / mask_width,
		(input.y / fPixelHeight - mask_y) / mask_height
	);
	
	float4 masktexture = tex2D(masktex, maskUV);
	
	// Use luminance as the alpha proxy
	float maskAlpha = dot(masktexture.rgb, float3(0.299, 0.587, 0.114));
	
	// Blend from black to maintexture
	color = lerp(0, maintexture, maskAlpha);

    return color;
}

technique tech_main
{
    pass p0 
    { 
        PixelShader = compile ps_2_0 PS_Main();
    }
}
