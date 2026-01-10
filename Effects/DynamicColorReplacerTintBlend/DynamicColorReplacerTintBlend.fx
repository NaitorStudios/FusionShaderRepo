sampler2D img = sampler_state
{
      MinFilter = Point;
      MagFilter = Point;
};
sampler2D bkd : register(s1);

#define COLORS 8

float4 from[COLORS];
float4 to[COLORS];
float4 tint;
int blend;

#define THRESHOLD (0.33/255)

bool unequal(inout float4 test, in float3 from, in float3 to)
{
    if (distance(test.rgb, from) < THRESHOLD) {
        test.rgb = to;
        return false;
    }
    else
        return true;
}

float4 ps_main(in float2 In : TEXCOORD0) : COLOR0
{
    float4 img = tex2D(img,In);
	float4 bkd = tex2D(bkd,In);
		
	for (int i = 0; i < COLORS ; i++ )
		unequal(img, from[i].rgb, to[i].rgb);
 
	img.rgb *= tint.rgb;
	
	if (blend == 1)
		img.rgb = saturate(img.rgb+bkd.rgb);
	if (blend == 2)
		img.rgb = max(0, bkd.rgb - img.rgb);	
	
    return img;
}

technique tech_main {
    pass { PixelShader = compile ps_2_a ps_main(); }
}