
struct PS_INPUT
{
  float4 Tint : COLOR0;
  float2 texCoord : TEXCOORD0;
  float4 Position : SV_POSITION;
};

struct PS_OUTPUT
{
    float4 Color : SV_TARGET;
};

Texture2D<float4> Tex0 : register(t0);
sampler TexSampler0 : register(s0);

cbuffer PS_VARIABLES : register(b0)
{
	const float fWidth;
	const float fHeight;
	const float4 fColour;
}

static const float2 samples[8] = {
-1.0,-1.0,
 0.0,-1.0,
 1.0,-1.0,
-1.0, 0.0,
 1.0, 0.0,
-1.0, 1.0,
 0.0, 1.0,
 1.0, 1.0,
};

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
    Out.Color = Tex0.Sample(TexSampler0, In.texCoord) * In.Tint;
    if ( Out.Color.a < 0.5f )
    {
        [unroll]for(int i=0; i<8; i++)
        {
            if ( Tex0.Sample(TexSampler0, In.texCoord + samples[i]/float2(fWidth,fHeight)).a >= 0.5f )
            {
                Out.Color = fColour;
                break;
            }
        }
    }
	
    return Out;
}

