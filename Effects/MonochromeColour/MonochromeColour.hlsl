struct PS_INPUT
{
    float4 Tint : COLOR0;
    float2 texCoord : TEXCOORD0;
    float4 Position : SV_POSITION;
};

//The source image
Texture2D<float4> img : register(t0);
sampler imgSampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float4 keep;
}

//This function will be called for each pixel in our texture and returns the new color
float4 ps_main(PS_INPUT In) : SV_TARGET
{

	//Read the color of the source texture at the current position (In)
	float4 color = img.Sample(imgSampler, In.texCoord) * In.Tint;
	
	if(color.r != keep.r || color.g != keep.g || color.b != keep.b) 
	{
		float4 f4 = color * float4(0.299f, 0.587f, 0.114f, 1.0f);
		float f = f4.r + f4.g + f4.b;
		color.rgb = f;
	}

	//Output the color
	return color;
}

