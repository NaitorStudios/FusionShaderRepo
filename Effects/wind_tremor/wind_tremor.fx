sampler2D img ;
float raito;
float weight;
float4 ps_main( float2 uv : TEXCOORD0 ) : COLOR0 {
	float y = (1.0 - uv.y);
	y = ( y * y * 0.3333 ) * weight;
	uv.x += sin( y ) * ( raito ) ;
	return tex2D(img , float2(uv.x , uv.y) );
}
technique tech_main {pass P0{PixelShader = compile ps_2_0 ps_main();}}