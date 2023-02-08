float fPixelWidth;
float fPixelHeight;
int mask_width;
int mask_height;
int mask_x;
int mask_y;
sampler2D Tex0;
sampler2D masktex : register(s1);


float4  PS_Main(float4 color : COLOR0, in float2  input : TEXCOORD0) :	COLOR0
{

float4 maintexture = tex2D(Tex0,input);

if(
(input.x /  fPixelWidth < mask_x )
|| (input.x /  fPixelWidth >( mask_x + mask_width))
|| (input.y /  fPixelHeight < mask_y )
|| (input.y /  fPixelHeight >( mask_y + mask_height))
)
{

color = 0;
}

else
{

float4 masktexture = tex2D(masktex,float2((input.x/  fPixelWidth - mask_x)/mask_width,  (input.y/  fPixelHeight - mask_y)/mask_height ));

if( masktexture.a != 0 )
{
color.rgb = maintexture.rgb;
color.a = masktexture.a ;
}
else
{
color = 0;
}

}

  return color;
}


technique tech_main
{
 pass p0
 {
       PixelShader =  compile ps_2_0   PS_Main();
 }
}
