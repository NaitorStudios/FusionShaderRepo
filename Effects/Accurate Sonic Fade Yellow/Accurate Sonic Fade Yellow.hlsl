struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};


Texture2D<float4> Tex0 : register(t0);
sampler Tex0Sampler : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	float FadeTransition;
}

float4 ps_main(in PS_INPUT In) : SV_TARGET
{ 
	//Variables
	float4 Col = Tex0.Sample(Tex0Sampler, In.texCoord) * In.Tint;
                float transition;
                
                //Change transition value
                transition = FadeTransition*0.03;

                //Change the colors 
				Col.r = clamp(transition, 0, Col.r); // Adjust the red channel
				Col.g = clamp(transition, 0, Col.g); // Adjust the green channel
				Col.b = clamp(transition + Col.r + Col.g, 0, Col.b); // Adjust the blue channel
                return Col;
}
