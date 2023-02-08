
sampler2D img : register(s0);
float bitmap_width;

float bitmap_height;

float x_scale;

float y_scale;

float4 ps_main(in float2 texCoord : TEXCOORD0) : COLOR0	{
float2 sz = float2(bitmap_width, bitmap_height);

float3 step = float3(1.0 / x_scale, 1.0 / y_scale, 0);

float2 tex_pixel = sz * texCoord.xy - step.xy / 2;

float2 corner = floor(tex_pixel) + 1;

float2 frac = min((corner - tex_pixel) * float2(x_scale, y_scale), float2(1.0, 1.0));

float4 c1 = tex2D(img, (floor(tex_pixel + step.zz) + 0.5) / sz);

float4 c2 = tex2D(img, (floor(tex_pixel + step.xz) + 0.5) / sz);

float4 c3 = tex2D(img, (floor(tex_pixel + step.zy) + 0.5) / sz);

float4 c4 = tex2D(img, (floor(tex_pixel + step.xy) + 0.5) / sz);
	

c1 *=   frac.x  *        frac.y;

c2 *= (1.0 - frac.x) *        frac.y;
c3 *=   frac.x  * (1.0 - frac.y);

c4 *= (1.0 - frac.x) * (1.0 - frac.y);

return 1.0 * (c1 + c2 + c3 + c4);

}

technique tech_main	{ pass P0 { PixelShader = compile ps_2_a ps_main(); }  }