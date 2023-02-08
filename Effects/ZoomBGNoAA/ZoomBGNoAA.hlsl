
struct PS_INPUT {
	float4 tint : COLOR0;
	float2 texCoord : TEXCOORD0;
	float4 position : SV_POSITION;
};

Texture2D<float4> img : register(t1);
sampler imgSampler : register(s1);

cbuffer PS_VARIABLES : register(b0) {
	// This shader will include a predefined variable to control the zoom level.
	float zoom;
}

// Again, we have the standard main shader function...
float4 ps_main(in PS_INPUT In) : SV_TARGET {

// Next, we calculate the coordinates from which we will sample. Since coordinates range from 0 to 1, we can scale an image simply by dividing texCoord by the zoom factor. The other parts are there to ensure we zoom in on the centre of the image.
float2 newCoord = ((In.texCoord-0.5)/zoom)+0.5;

// Again, we sample the new pixel, and output the result.
float4 newColor = img.Sample( imgSampler, newCoord );
return newColor;
}
