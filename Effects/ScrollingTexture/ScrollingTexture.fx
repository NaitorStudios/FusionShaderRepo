sampler2D Tex0 : register(s0); 
sampler2D Overlay; 

int tw, th = 32;
float fPixelHeight, fPixelWidth = 1;
float xOffset, yOffset;
float4 tint;

float Intensity = 1.0;

float4 MyShader(float2 Tex : TEXCOORD0 ) : COLOR0
{
    float4 Color;
    float4 output = 1;

    //Get Texture scaling ratios.
    float ratioX=  (1 / fPixelWidth) / tw;
    float ratioY=  (1 / fPixelHeight) / th;

    Color = tex2D( Tex0, Tex.xy);

    output = tex2D ( Overlay, float2(  Tex.x  * ratioX + xOffset ,  Tex.y * ratioY + yOffset ));
	// Alpha Overlay
	output.a = lerp(0.0, Color.a * output.a, Intensity);
	output.rgb = output.rgb - (Intensity-1.0);
	
    return output ;
}


technique PostProcess
{
    pass p1
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 MyShader();
    }

}
