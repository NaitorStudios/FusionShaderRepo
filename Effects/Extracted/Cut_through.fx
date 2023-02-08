sampler2D img : register(s0);
sampler2D bkd : register(s1);
sampler2D texture_img : register(s2);

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {

float4 imcol = tex2D(img,In);
float4 bkcol = tex2D(bkd,In);
float4 txcol = tex2D(texture_img,In);

if ( any(bkcol.rgb) > 0 )
{imcol=txcol;}

return imcol;

}

technique tech_main {pass P0 {PixelShader=compile ps_2_0 ps_main();}}