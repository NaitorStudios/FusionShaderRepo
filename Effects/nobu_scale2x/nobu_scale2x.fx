float fPixelWidth,fPixelHeight;
float scaleAmt, scaleAmt2;

// Global variables
sampler2D Tex0;

float4 ps_main( float2 Tex : TEXCOORD0 ) : COLOR0
{

    fPixelWidth *= scaleAmt2;
    fPixelHeight *= scaleAmt2;

    float2 scalepos = {scaleAmt/floor(Tex.x*scaleAmt), scaleAmt/floor(Tex.y*scaleAmt)};
    float2 scalepos2 = {scaleAmt/round(Tex.x*scaleAmt), scaleAmt/round(Tex.y*scaleAmt)};

    float4 A = tex2D(Tex0,float2(Tex.x-fPixelWidth,Tex.y-fPixelHeight));
    float4 B = tex2D(Tex0,float2(Tex.x,Tex.y-fPixelHeight));
    float4 C = tex2D(Tex0,float2(Tex.x+fPixelWidth,Tex.y-fPixelHeight));
    float4 D = tex2D(Tex0,float2(Tex.x-fPixelWidth,Tex.y));
    float4 E = tex2D(Tex0,Tex.xy);
    float4 F = tex2D(Tex0,float2(Tex.x+fPixelWidth,Tex.y));
    float4 G = tex2D(Tex0,float2(Tex.x-fPixelWidth,Tex.y+fPixelHeight));
    float4 H = tex2D(Tex0,float2(Tex.x,Tex.y+fPixelHeight));
    float4 I = tex2D(Tex0, float2(Tex.x+fPixelWidth,Tex.y+fPixelHeight));

    float4 Out = E;

    float4 E0;
    float4 E1;
    float4 E2;
    float4 E3;

//    if (B.rgb != H.rgb && D.rgb != F.rgb) {

    if (B.r !=H.r  &&  B.g != H.g  &&  B.b != H.b   && D.r !=F.r  &&  D.g != F.g  &&  D.b != F.b  ) {
	E0 = D == B ? D : E;
	E1 = B == F ? F : E;
	E2 = D == H ? D : E;
	E3 = H == F ? F : E;
    } else {
	E0 = E;
	E1 = E;
	E2 = E;
	E3 = E;
    }

    if (scalepos.x == scalepos2.x  && scalepos.y == scalepos2.y) Out = E0;
    if (scalepos.x != scalepos2.x  && scalepos.y == scalepos2.y) Out = E1;
    if (scalepos.x == scalepos2.x  && scalepos.y != scalepos2.y) Out = E2;
    if (scalepos.x != scalepos2.x  && scalepos.y != scalepos2.y) Out = E3;


   return Out;
}



//
// Technique
//

technique Scale2x_New
{
    pass P0
    {
		// shaders
		VertexShader = NULL;
		PixelShader  = compile ps_2_a ps_main();
    }  
}
