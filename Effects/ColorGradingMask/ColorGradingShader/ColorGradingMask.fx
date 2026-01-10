sampler2D img : register(s0);
sampler2D bkd : register(s1);
sampler2D LUTa : register(s2) = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
};
sampler2D LUTb : register(s3) = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
};
int lutSize, addLUT;
float blend;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0 {
	float maxColor = lutSize - 1.0;
	float4 imgColor = saturate(tex2D(bkd, In));
	float halfColX = 0.5 / (lutSize * lutSize);
	float halfColY = 0.5 / lutSize;
	float threshold = maxColor / lutSize;
	
	float xOffset = halfColX + imgColor.r * threshold / lutSize;
	float yOffset = halfColY + imgColor.g * threshold;
	float cell = floor(imgColor.b * maxColor);
	
	float2 lutPos = float2(cell / lutSize + xOffset, yOffset);
	float4 gradedColA = tex2D(LUTa, lutPos);
		
	float4 output;
	if ( addLUT == 1 ) {
		float4 gradedColB = tex2D(LUTb, lutPos);
		output = lerp(gradedColB, gradedColA, blend);
	} else
		output = lerp(imgColor, gradedColA, blend);
	
	output.a = tex2D(img, In).a;
	return output;
}


technique tech_main {
    pass P0 {
        PixelShader = compile ps_2_0 ps_main();
    }
}