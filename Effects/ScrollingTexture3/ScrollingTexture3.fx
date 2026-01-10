sampler2D Tex0 : register(s0) = sampler_state {
AddressU = wrap;
AddressV = wrap;
};

float tw, th = 32;
float fPixelHeight, fPixelWidth;
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

    output = tex2D ( Tex0, float2(  Tex.x  * ratioX + xOffset ,  Tex.y * ratioY + yOffset ));
	
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
