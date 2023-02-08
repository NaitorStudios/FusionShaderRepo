sampler2D img : register(s0);
sampler2D bkd : register(s1);
sampler2D texture_img : register(s2);
float ox;
float oy;
float xcoeff;
float ycoeff;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {

float2 txcol;
float4 imcol = tex2D(img,In);
float4 bkcol = tex2D(bkd,In);

if ( any(bkcol.rgb) > 0 )
{
txcol.x = abs(In.x+(ox*xcoeff));
txcol.y =  abs(In.y+(oy*ycoeff));
imcol=tex2D(texture_img,txcol);}

return imcol;

}

technique tech_main {pass P0 {PixelShader=compile ps_2_0 ps_main();}}