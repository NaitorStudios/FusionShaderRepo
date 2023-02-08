sampler2D bkd : register(s1);
sampler2D texture_img : register(s2);

float ox;
float oy;
float xcoeff;
float ycoeff;

float4 ps_main(float2 In : TEXCOORD0) : COLOR0 {

float4 bkcol = tex2D(bkd,In);
float2 txcol;

txcol.x = In.x+(abs(ox)*xcoeff);
txcol.y =  In.y+(abs(oy)*ycoeff);

float4 imcol = tex2D(texture_img,txcol);

if ( any(bkcol.rgb) > 0 )
{
imcol.r*=0.09;
imcol.g*=0.06;
imcol.b*=1.1;
}

return imcol;

}

technique tech_main {pass P0 {PixelShader=compile ps_2_0 ps_main();}}