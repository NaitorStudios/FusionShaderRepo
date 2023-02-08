
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
};

struct PS_OUTPUT
{
    float4 Color   : SV_TARGET;
};

// Global variables
Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

// User Input variables
cbuffer PS_VARIABLES : register(b0)
{
	float f_X1;
	float f_Y1;
	float f_X2;
	float f_Y2;
	float f_X3;
	float f_Y3;
	float f_X4;
	float f_Y4;
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
	float oldX = In.texCoord.x;
	float oldY = In.texCoord.y;
	
	float scaleX1 = f_X2 - f_X1;
	float scaleX2 = f_X4 - f_X3;
	float scaleY1 = f_Y3 - f_Y1;
	float scaleY2 = f_Y4 - f_Y2;
	
	float newX = (oldX * ((scaleX1 * (1.0f-oldY)) + scaleX2 * oldY)) + ((f_X1 * (1.0f-oldY)) + (f_X3 * oldY));
	float newY = (oldY * ((scaleY1 * (1.0f-oldX)) + scaleY2 * oldX)) + ((f_Y1 * (1.0f-oldX)) + (f_Y2 * oldX));
	
	Out.Color = Tex0.Sample(Tex0Sampler, float2(newX,newY)) * In.Tint;
	
    return Out;
}
