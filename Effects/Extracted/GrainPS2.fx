
// Pixel shader input structure
struct PS_INPUT
{
    float4 Position   : POSITION;
    float2 Texture    : TEXCOORD0;
};

// Pixel shader output structure
struct PS_OUTPUT
{
    float4 Color   : COLOR0;
};

// Global variables
sampler2D Texture0;

float fSeed;
float fStrength;
float fAdvA,fAdvB,fAdvC,fAdvD,fAdvE;
bool iR,iG,iB,iA,iInvert;

/* Random algorithm by Sylvain Lefebvre */

#define M_PI 3.14159265358979323846

float mccool_rand(float2 ij) {
  const float4 a=float4(pow(M_PI,4),exp(5),pow(13, M_PI / 2.0),sqrt(1997.0));
  float4 result =float4(ij,ij);

  for(int i = 0; i < 3; i++) {
		result.x = frac(dot(result, a));
		result.y = frac(dot(result, a));
		result.z = frac(dot(result, a));
		result.w = frac(dot(result, a));
  }
  return (float)result.xy;
}

PS_OUTPUT ps_main( in PS_INPUT In )
{
    // Output pixel
    PS_OUTPUT Out;
  	Out.Color = tex2D(Texture0,In.Texture);
  	float rand = mccool_rand(In.Texture+fSeed)*fStrength; rand = iInvert ? 1-rand : rand;
		if(iR) Out.Color.r *= rand;
		if(iG) Out.Color.g *= rand;
		if(iB) Out.Color.b *= rand;
		if(iA) Out.Color.a *= rand;
    return Out;
}

// Effect technique
technique tech_main
{
    pass P0
    {
        // shaders
        VertexShader = NULL;
        PixelShader  = compile ps_2_0 ps_main();
    }  
}