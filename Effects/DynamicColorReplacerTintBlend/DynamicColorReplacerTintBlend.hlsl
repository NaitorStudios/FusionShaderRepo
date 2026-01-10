struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);
Texture2D<float4> bkd : register(t1);
sampler bkdSampler : register(s1);

#define COLORS 8

cbuffer PS_VARIABLES : register(b0)
{
	float4 from[COLORS];
	float4 to[COLORS];
	float4 tint;
	int blend;
}

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

float4 Demultiply(float4 _color)
{
	float4 color = _color;
	if ( color.a != 0 )
		color.rgb /= color.a;
	return color;
}

float4 ps_main( in PS_INPUT In ) : SV_TARGET
{
    float4 img = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord));
	float4 bg = bkd.Sample(bkdSampler, In.texCoord);
		
	for (int i = 0; i < COLORS ; i++ )
		unequal(img, from[i].rgb, to[i].rgb);
 
	img.rgb *= tint.rgb;
	
	if (blend == 1)
		img.rgb = saturate(img.rgb+bg.rgb);
	if (blend == 2)
		img.rgb = max(0, bg.rgb - img.rgb);	
	
	img.a *= In.Tint.a;
    return img;
}

float4 ps_main_pm( in PS_INPUT In ) : SV_TARGET
{
    float4 img = Demultiply(Tex0.Sample(Tex0Sampler, In.texCoord));
	float4 bg = bkd.Sample(bkdSampler, In.texCoord);
		
	for (int i = 0; i < COLORS ; i++ )
		unequal(img, from[i].rgb, to[i].rgb);
 
	img.rgb *= tint.rgb;
	
	if (blend == 1)
		img.rgb = saturate(img.rgb+bg.rgb);
	if (blend == 2)
		img.rgb = max(0, bg.rgb - img.rgb);	
	
	img.a *= In.Tint.a;
	img.rgb *= img.a;
    return img;
}
