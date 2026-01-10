sampler2D mask : register(s0);
sampler2D bkd : register(s1);
sampler2D LUTa : register(s2) = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
};
sampler2D LUTb : register(s3) = sampler_state {
    MinFilter = Linear;
    MagFilter = Linear;
};
int lutSize;
float blend;

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0 {
    float4 imgColor = tex2D( bkd, In );
    float red = ( imgColor.r * ( lutSize - 1 ) + 0.5 ) / ( lutSize * lutSize );
    float green = ( imgColor.g * ( lutSize - 1 ) + 0.5 ) / lutSize;
    float blueA = floor( imgColor.b * ( lutSize - 1 ) ) / lutSize;
    float blueB = ceil( imgColor.b * ( lutSize - 1 ) ) / lutSize;
    float4 colorAa = tex2D( LUTa, float2( blueA + red, green ));
    float4 colorBa = tex2D( LUTa, float2( blueB + red, green ));
    float lerpABa = ( imgColor.b - ( blueA + red )) / (( blueB + red ) - ( blueA + red ));
    float4 colorOuta = lerp( colorAa, colorBa, lerpABa );
		
	float4 colorAb = tex2D( LUTb, float2( blueA + red, green ));
	float4 colorBb = tex2D( LUTb, float2( blueB + red, green ));
	float lerpABb = ( imgColor.b - ( blueA + red )) / (( blueB + red ) - ( blueA + red ));
	float4 colorOutb = lerp( colorAb, colorBb, lerpABb );
	
	return lerp( imgColor, lerp(colorOuta, colorOutb, tex2D(mask, In).a), blend );
	
}

technique tech_main {
    pass P0 {
        PixelShader = compile ps_2_0 ps_main();
    }
}